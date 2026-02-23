//
//  ChangePasswordView.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import SwiftUI
import KeychainAccess

struct ChangePasswordView: View {
    @Binding var isPresented: Bool

    private let keychain = Keychain(service: "com.kirill.FileManager")
    private let passwordKey = "userPassword"

    @State private var password: String = ""
    @State private var firstPassword: String = ""
    @State private var step: Step = .first
    @State private var errorMessage: String = ""

    private enum Step { case first, confirm }

    private var buttonTitle: String {
        step == .first ? "Продолжить" : "Сохранить пароль"
    }

    private var titleText: String {
        step == .first ? "Новый пароль" : "Повторите пароль"
    }

    private var hintText: String {
        step == .first
            ? "Придумайте новый пароль\n(минимум 4 символа)"
            : "Введите пароль ещё раз для подтверждения"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "key.fill")
                    .font(.system(size: 52, weight: .thin))
                    .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.58))

                Text(titleText)
                    .font(.title2.bold())

                Text(hintText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                SecureField("Пароль", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                    .id(step == .first ? "first" : "confirm")

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Button {
                    handleTap()
                } label: {
                    Text(buttonTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.24, green: 0.78, blue: 0.58))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .navigationTitle("Смена пароля")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") { isPresented = false }
                }
            }
        }
    }

    private func handleTap() {
        errorMessage = ""
        switch step {
        case .first:
            guard password.count >= 4 else {
                errorMessage = "Пароль должен быть не менее 4 символов"
                return
            }
            firstPassword = password
            password = ""
            step = .confirm

        case .confirm:
            if password == firstPassword {
                keychain[passwordKey] = password
                isPresented = false
            } else {
                errorMessage = "Пароли не совпадают. Начните заново."
                password = ""
                firstPassword = ""
                step = .first
            }
        }
    }
}
