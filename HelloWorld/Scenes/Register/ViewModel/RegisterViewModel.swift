//
//  RegisterViewModel.swift
//  HelloWorld
//
//  Created by Ana Camila Lopez Rojano on 28/10/26.
//

//

import Combine

class RegisterViewModel {
    
    // Modelo
    var model = RegisterModel()
    
    // PUBLISHED: Un contenedor de propiedad que se utiliza dentro de unas clase, pero la clase tiene que ser observable
    // para NOTIFICAR AUTMATICAMENTE a la interfaz de usuario (View) cuando cambia el valor de una propiedad
    
    //Variable para notificar si el form es válido
    //Habilitar o deshabilitar el boton de login o iniciar sesión
    @Published var isValidForm: Bool = false
        
    // Variable USUARIO
    var user: User {
        get { model.user }
        set { model.user = newValue }
    }
    
    // Función para validar el form
    func validateForm() {
        print("User: \(user)")
        isValidForm = !(user.username.isEmpty || user.name.isEmpty || user.lastname.isEmpty || user.password.isEmpty || user.confirmpassword.isEmpty)
    }
}
    


