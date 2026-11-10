//
//  ViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 16/10/26.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    //MARK: - Propiedades privadas
    //Contenedor de los published
    private var cancellables = Set<AnyCancellable>()
    
    // ViewModel
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: -
        
        viewModel.$isValidForm
            .sink { [weak self] isValid in
                guard let self else { return }
                loginButton.isEnabled = isValid
            }
            .store(in: &cancellables)
        
        // Ocultar el teclado picando cualquier parte de la pantalla
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Asigna delegados a los TextFields
        userTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //Botón Login

    @IBAction func loginTapped() {
        print("loginTapped, nav:", navigationController as Any)

        guard let nv = navigationController // Asegura que una variable NULL (nll) NO SEA NULL
        else {
            return
        }
        
    
        // Sigue porque navigationController NO ES NULL
        
        let name = viewModel.user.username
            let homeViewController = UIStoryboard(name: "Home", bundle: nil)
                .instantiateViewController(identifier: "HomeViewController") { coder in
                    HomeViewController(coder: coder, name: name)
                }
            nv.pushViewController(homeViewController, animated: true)
        }
       
    
    @IBAction func RegisterTapped() {

        guard let nv = navigationController else {
            return
        }

        let storyBoard = "Register"
        let id = "RegisterViewController"

        let registerViewController = UIStoryboard(
            name: storyBoard,
            bundle: nil
        ).instantiateViewController(
            withIdentifier: id
        )

        nv.pushViewController(registerViewController, animated: true)
    }
    
}



// Separa el delegado que ocupa el TextField
extension MainViewController: UITextFieldDelegate {
    
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
        
        if textField == userTextField {
            viewModel.user.username = updatedText
        }
        else if textField == passwordTextField {
            viewModel.user.password = updatedText
        }
        
        viewModel.validateForm()
        
        return true
    }
}

