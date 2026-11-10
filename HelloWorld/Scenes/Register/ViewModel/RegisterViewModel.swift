//
//  RegisterViewModel.swift
//  HelloWorld
//
//  Created by Ana Camila Lopez Rojano on 28/10/26.
//

//
import Foundation
import Combine

class RegisterViewModel {

    // Modelo
    var model = RegisterModel()

    // Variable para notificar si el formulario es válido
    @Published var isValidForm: Bool = false

    // Mensaje de error por campo (nil = sin error, el label se oculta)
    @Published var usernameError: String?
    @Published var nameError: String?
    @Published var lastnameError: String?
    @Published var passwordError: String?
    @Published var confirmpasswordError: String?

    // Variable usuario que obtenemos del modelo
    var user: User {
        get { model.user }
        set { model.user = newValue }
    }

    // Función para validar el formulario (se llama en cada cambio de texto)
    func validateForm() {
        let u = usernameMessage(user.username)
        let n = nameMessage(user.name, field: "El nombre")
        let l = nameMessage(user.lastname, field: "El apellido")
        let p = passwordMessage(user.password)
        let c = confirmMessage(user.confirmpassword, password: user.password)

        // Solo se muestra el error si el campo ya tiene texto
        usernameError = user.username.isEmpty ? nil : u
        nameError = user.name.isEmpty ? nil : n
        lastnameError = user.lastname.isEmpty ? nil : l
        passwordError = user.password.isEmpty ? nil : p
        confirmpasswordError = user.confirmpassword.isEmpty ? nil : c

        // El botón se habilita solo si TODOS los campos son válidos
        isValidForm = (u == nil && n == nil && l == nil && p == nil && c == nil)
    }

    // MARK: - Reglas por campo (devuelven el mensaje de error, o nil si es válido)

    private func usernameMessage(_ value: String) -> String? {
        let text = value.trimmingCharacters(in: .whitespaces)
        if text.isEmpty { return "El usuario es obligatorio." }
        if text.count < 4 { return "Mínimo 4 caracteres." }
        if text.count > 20 { return "Máximo 20 caracteres." }
        let allowed = text.allSatisfy { char in
            (char.isASCII && (char.isLetter || char.isNumber)) || char == "_" || char == "."
        }
        if !allowed { return "Solo letras, números, _ y ." }
        return nil
    }

    private func nameMessage(_ value: String, field: String) -> String? {
        let text = value.trimmingCharacters(in: .whitespaces)
        if text.isEmpty { return "\(field) es obligatorio." }
        if text.count < 2 { return "Mínimo 2 caracteres." }
        // isLetter acepta acentos y ñ
        let onlyLetters = text.allSatisfy { char in char.isLetter || char == " " }
        if !onlyLetters { return "Solo puede contener letras." }
        return nil
    }

    private func passwordMessage(_ value: String) -> String? {
        if value.isEmpty { return "La contraseña es obligatoria." }
        if value.count < 8 { return "Mínimo 8 caracteres." }
        if value.contains(" ") { return "No puede tener espacios." }
        if !value.contains(where: { $0.isUppercase }) { return "Incluye al menos una mayúscula." }
        if !value.contains(where: { $0.isLowercase }) { return "Incluye al menos una minúscula." }
        if !value.contains(where: { $0.isNumber }) { return "Incluye al menos un número." }
        if !value.contains(where: { !$0.isLetter && !$0.isNumber }) { return "Incluye al menos un símbolo (!@#$%...)." }
        return nil
    }

    private func confirmMessage(_ value: String, password: String) -> String? {
        if value.isEmpty { return "Confirma tu contraseña." }
        if value != password { return "Las contraseñas no coinciden." }
        return nil
    }
}


