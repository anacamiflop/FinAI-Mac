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
    
    @IBAction func loginTapped() {
        guard let nv = navigationController // Asegura que una variable NULL (nll) NO SEA NULL
        else {
            return
        }
        // Sigue porque navigationController NO ES NULL
        
        let storyBoard = "Home"
        let id = "HomeViewController"
        
        let homeViewController = UIStoryboard(
            name : storyBoard,
            bundle: nil
        ).instantiateViewController(
            identifier: id
        ) {coder in
            let name = "P. Diddy"
            let viewController = HomeViewController(coder: coder)
            return viewController
            
            // return HomeViewController (coder: coder, name: name)

        }
        nv.pushViewController(homeViewController, animated: true)
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

