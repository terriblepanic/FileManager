//
//  FileManagerApp.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import SwiftUI

@main
struct FileManagerApp: App {
    @State private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView {
                    isLoggedIn = true
                }
            }
        }
    }
}
