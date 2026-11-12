//
//  RegisterViewController.swift
//  HelloWorld
//
//  Created by Ana Camila Lopez Rojano on 28/10/26.
//

//
//  ViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 16/10/26.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var lastnameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmpasswordErrorLabel: UILabel!
    
    
    @IBOutlet weak var  RegisterButton: UIButton!
    
    //MARK: - Propiedades privadas
    //Contenedor de los published
    private var cancellables = Set<AnyCancellable>()
    
    // ViewModel
    private let viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        viewModel.$isValidForm
            .sink { [weak self] isValid in
                guard let self else { return }
                RegisterButton.isEnabled = isValid
            }
            .store(in: &cancellables)
        
        // Ocultar el teclado picando cualquier parte de la pantalla
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Asigna delegados a los TextFields
        usernameField.delegate = self
        nameTextField.delegate = self
        lastnameTextField.delegate = self
        passwordTextField.delegate = self
        confirmpasswordTextField.delegate = self
        
    }
    
    @IBAction func registerTapped() {
        guard let nv = navigationController else { return }

        // Guarda los datos en UserDefaults (vía ViewModel)
        viewModel.saveUser()

        let alert = UIAlertController(
            title: "Registro exitoso",
            message: "Tu cuenta fue creada correctamente",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Regresa al MainViewController
            nv.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
}

// Separa el delegado que ocupa el TextField
extension RegisterViewController: UITextFieldDelegate {
    
    // Detecta cuando le picamos al enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Cambios en TextFields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // If el texto es caracter especial return false, sino return true
        
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        print("Texto: \(updatedText)")
        
      
        if textField == usernameField {
            viewModel.user.username = updatedText
        }
            else if textField == nameTextField {
            viewModel.user.name = updatedText
        }
        else if textField == lastnameTextField {
            viewModel.user.lastname = updatedText
        }
        else if textField ==
                    passwordTextField {
            viewModel.user.password = updatedText
        }
        else if textField ==
                    confirmpasswordTextField {
            viewModel.user.confirmpassword = updatedText
        }
        
        viewModel.validateForm()
        
        return true
    }
}

