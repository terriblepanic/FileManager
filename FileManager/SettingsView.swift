//
//  SettingsView.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import SwiftUI
import KeychainAccess

struct SettingsView: View {
    @ObservedObject private var settings = SettingsStore.shared
    @State private var showChangePassword = false

    var body: some View {
        NavigationStack {
            List {
                Section("Отображение") {
                    Toggle(isOn: $settings.sortAscending) {
                        Label("Алфавитный порядок", systemImage: "textformat.abc")
                    }
                    .tint(Color(red: 0.24, green: 0.78, blue: 0.58))
                }

                Section("Безопасность") {
                    Button {
                        showChangePassword = true
                    } label: {
                        Label("Изменить пароль", systemImage: "key.fill")
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Настройки")
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView(isPresented: $showChangePassword)
            }
        }
    }
}
