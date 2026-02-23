//
//  SettingsStore.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import Foundation
import Combine

final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    private let sortAscendingKey = "sortAscending"

    @Published var sortAscending: Bool {
        didSet {
            UserDefaults.standard.set(sortAscending, forKey: sortAscendingKey)
        }
    }

    private init() {
        if UserDefaults.standard.object(forKey: sortAscendingKey) == nil {
            UserDefaults.standard.set(true, forKey: sortAscendingKey)
            self.sortAscending = true
        } else {
            self.sortAscending = UserDefaults.standard.bool(forKey: sortAscendingKey)
        }
    }
}
