import SwiftUI
import PlaygroundSupport

struct FocusedTextFieldValueKey: FocusedValueKey {
    typealias Value = String
}

struct FocusedTextFieldBindingKey: FocusedValueKey {
    typealias Value = Binding<String>
}

extension FocusedValues {
    var textFieldValue: FocusedTextFieldValueKey.Value? {
        get { self[FocusedTextFieldValueKey.self] }
        set { self[FocusedTextFieldValueKey.self] = newValue }
    }

    var textFieldBinding: FocusedTextFieldBindingKey.Value? {
        get { self[FocusedTextFieldBindingKey.self] }
        set { self[FocusedTextFieldBindingKey.self] = newValue }
    }
}

struct LoginForm: View {
    @State private var username = ""
    @State private var password = ""

    enum Field: Hashable {
        case username
        case password
    }

    @FocusState var focusedField: Field?
    @FocusedValue(\.textFieldValue) var activeTextFieldValue
    @FocusedBinding(\.textFieldBinding) var activeTextFieldBinding

    var body: some View {
        VStack {
            Form {
                TextField("Username", text: $username)
                    .overlay(ClearButton())
                    .focused($focusedField, equals: .username)
                    .focusedValue(\.textFieldValue, username)
                    .focusedValue(\.textFieldBinding, $username)

                SecureField("Password", text: $password)
                    .overlay(ClearButton())
                    .focused($focusedField, equals: .password)
                    .focusedValue(\.textFieldValue, password)
                    .focusedValue(\.textFieldBinding, $password)

                Button("Sign In") {
                    if username.isEmpty {
                        focusedField = .username
                    } else if password.isEmpty {
                        focusedField = .password
                    } else {
                        print("Sign in")
                    }
                }

                Section {
                    Text("The field value is:")
                    Text(activeTextFieldValue ?? "")
                }

                Section {
                    HStack {
                        Button(action: {
                            activeTextFieldBinding = activeTextFieldBinding?.uppercased()
                        }) {
                            Image(systemName: "abc")
                        }

                        Button(action: {
                            activeTextFieldBinding = activeTextFieldBinding?.lowercased()
                        }) {
                            Image(systemName: "textformat.abc")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

struct ClearButton: View {
    @FocusedBinding(\.textFieldBinding) var textFieldBinding

    var body: some View {
        Button(action: {
            textFieldBinding = ""
        }) {
            ZStack(alignment: .trailing) {
                Color.clear
                Image(systemName: "xmark.circle.fill")
            }
        }
        .disabled(textFieldBinding?.isEmpty == true)
        .opacity(textFieldBinding == nil ? 0 : 1)
    }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: LoginForm())

