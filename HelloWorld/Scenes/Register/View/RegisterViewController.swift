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

    // MARK: - Componentes visuales
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

    @IBOutlet weak var RegisterButton: UIButton!

    // MARK: - Propiedades privadas
    // Contenedor de los published
    private var cancellables = Set<AnyCancellable>()

    // ViewModel
    private let viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Habilita o deshabilita el botón según si el formulario es válido
        viewModel.$isValidForm
            .sink { [weak self] isValid in
                guard let self else { return }
                RegisterButton.isEnabled = isValid
            }
            .store(in: &cancellables)

        // Muestra u oculta el mensaje de error de cada campo
        bind(viewModel.$usernameError, to: usernameErrorLabel)
        bind(viewModel.$nameError, to: nameErrorLabel)
        bind(viewModel.$lastnameError, to: lastnameErrorLabel)
        bind(viewModel.$passwordError, to: passwordErrorLabel)
        bind(viewModel.$confirmpasswordError, to: confirmpasswordErrorLabel)

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

        // OJO: con esta línea nadie puede escribir en el usuario y el botón
        // nunca se habilita. Quítala si el usuario se escribe a mano.
        usernameField.isUserInteractionEnabled = false
    }

    // Conecta un @Published de error con su label
    private func bind(_ publisher: Published<String?>.Publisher, to label: UILabel) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { message in
                label.text = message
                label.isHidden = (message == nil)
            }
            .store(in: &cancellables)
    }

    @IBAction func registerTapped() {
        guard let nv = navigationController // Asegura que una variable NULL (nil) NO SEA NULL
        else {
            return
        }
        // Sigue porque navigationController NO ES NULL

        nv.popViewController(animated: true)
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

        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        if textField == usernameField {
            viewModel.user.username = updatedText
        } else if textField == nameTextField {
            viewModel.user.name = updatedText
        } else if textField == lastnameTextField {
            viewModel.user.lastname = updatedText
        } else if textField == passwordTextField {
            viewModel.user.password = updatedText
        } else if textField == confirmpasswordTextField {
            viewModel.user.confirmpassword = updatedText
        }

        viewModel.validateForm()

        return true
    }
}

