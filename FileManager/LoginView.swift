//
//  LoginView.swift
//  FileManager
//
//  Created by Кирилл Паничкин on 2/23/26.
//

import SwiftUI
import KeychainAccess

struct LoginView: View {
    private let keychain = Keychain(service: "com.kirill.FileManager")
    private let passwordKey = "userPassword"

    var onSuccess: () -> Void

    @State private var password: String = ""
    @State private var firstPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isSecure: Bool = true

    private enum CreationStep { case first, confirm }
    @State private var creationStep: CreationStep = .first

    private var hasPassword: Bool {
        keychain[passwordKey] != nil
    }

    private var buttonTitle: String {
        if hasPassword {
            return "Войти"
        }
        switch creationStep {
        case .first:   return "Создать пароль"
        case .confirm: return "Повторите пароль"
        }
    }

    private var hintText: String {
        if hasPassword {
            return "Введите пароль"
        }
        switch creationStep {
        case .first:   return "Придумайте пароль (минимум 4 символа)"
        case .confirm: return "Введите пароль ещё раз"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Иконка
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.58))
                .padding(.bottom, 32)

            Text("FileManager")
                .font(.title.bold())
                .padding(.bottom, 8)

            Text(hintText)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)

            // Поле ввода пароля
            HStack {
                Group {
                    if isSecure {
                        SecureField("Пароль", text: $password)
                    } else {
                        TextField("Пароль", text: $password)
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 32)

            // Ошибка
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .padding(.horizontal, 32)
            }

            // Кнопка
            Button {
                handleButtonTap()
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
            .padding(.top, 16)

            Spacer()
        }
    }

    private func handleButtonTap() {
        errorMessage = ""

        if hasPassword {
            if password == keychain[passwordKey] {
                onSuccess()
            } else {
                errorMessage = "Неверный пароль. Попробуйте ещё раз."
                password = ""
            }
        } else {
            switch creationStep {
            case .first:
                guard password.count >= 4 else {
                    errorMessage = "Пароль должен быть не менее 4 символов"
                    return
                }
                firstPassword = password
                password = ""
                creationStep = .confirm

            case .confirm:
                if password == firstPassword {
                    keychain[passwordKey] = password
                    onSuccess()
                } else {
                    errorMessage = "Пароли не совпадают. Начните заново."
                    password = ""
                    firstPassword = ""
                    creationStep = .first
                }
            }
        }
    }
}
