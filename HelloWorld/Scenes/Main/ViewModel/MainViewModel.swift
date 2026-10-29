//
//  MainViewModel.swift
//  HelloWorld
//
//  Created by Alumnos on 19/10/26.
//

// Un objeto de un CLASS es muy diferente al de un STRUCT ppor el uso de memoria

import Combine

class MainViewModel {
    
    // Modelo
    var model = MainModel()
    
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
        isValidForm = !(user.username.isEmpty || user.password.isEmpty)
    }
}
