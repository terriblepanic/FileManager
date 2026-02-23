//
//  Model.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import Foundation
import Combine

final class Model: ObservableObject {
    let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    @Published var items: [String] = []

    init() {
        print("Documents:", path)

        loadItems()
    }

    func loadItems() {
        let all = (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
        items = all
            .filter { $0.hasSuffix(".jpg") || $0.hasSuffix(".jpeg") || $0.hasSuffix(".png") }
            .sorted()
    }

    func addImage(named filename: String, data: Data) {
        let url = URL(fileURLWithPath: path + "/" + filename)
        try? data.write(to: url)
        loadItems()
    }

    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let pathForDelete = path + "/" + items[index]
            try? FileManager.default.removeItem(atPath: pathForDelete)
        }
        loadItems()
    }

    func fullPath(for filename: String) -> String {
        return path + "/" + filename
    }
}
