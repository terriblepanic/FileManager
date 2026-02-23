//
//  ContentView.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import SwiftUI
import PhotosUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Файлы", systemImage: "photo.on.rectangle")
                }
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(Color(red: 0.24, green: 0.78, blue: 0.58))
    }
}

struct ContentView: View {
    @StateObject private var model = Model()

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedFilename: String? = nil

    var body: some View {
        NavigationStack {
            Group {
                if model.items.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Documents")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.58))
                    }
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMdd_HHmmss"
                        let filename = "photo_\(formatter.string(from: Date())).jpg"
                        model.addImage(named: filename, data: data)
                    }
                    selectedItem = nil
                }
            }
        }
    }
    
    private var list: some View {
        List {
            Section("Фотографий: \(model.items.count)") {
                ForEach(model.items, id: \.self) { filename in
                    PhotoRow(
                        filename: filename,
                        fullPath: model.fullPath(for: filename)
                    )
                }
                .onDelete { offsets in
                    model.deleteItem(at: offsets)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60, weight: .thin))
                .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.58).opacity(0.7))

            Text("Нет фотографий")
                .font(.title2.weight(.semibold))

            Text("Нажмите + чтобы добавить\nфотографию из галереи")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
