//
//  ViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 16/10/26.
//

import UIKit
import Combine
import LocalAuthentication

class MainViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var lblWelcome: UILabel!
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let name = UserDefaults.standard.string(forKey: "name") ?? ""
            lblWelcome.text = "Bienvenido \(name)"
        // Limpia los campos al volver del registro
            userTextField.text = ""
            passwordTextField.text = ""
            viewModel.user.username = ""
            viewModel.user.password = ""
            viewModel.validateForm()
        }
    
    //Botón Login

    @IBAction func loginTapped() {

        guard let nv = navigationController // Asegura que una variable NULL (nll) NO SEA NULL
                
        
        else {
            return
        }
        
        guard viewModel.validateLogin() else {
                   let alert = UIAlertController(
                       title: "Error",
                       message: "Usuario o contraseña incorrectos",
                       preferredStyle: .alert
                   )
                   alert.addAction(UIAlertAction(title: "OK", style: .default))
                   present(alert, animated: true)
                   return
               }
    
        // Sigue porque navigationController NO ES NULL
        
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
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
    
    @IBAction func faceIDTapped(){
        let context = LAContext() // Crea nun contexto de autenticación biometrica
        var error: NSError? = nil // Variable para capturar posibles errores durante la evaluacion
        
        //Verifica si el dispositivo puede usar autenticacion biometrica (Face ID) / (Touch ID)
        let canUseBiometrics = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if canUseBiometrics{
            let reason = "Please authorize with Face ID" // Mensaje que se mostrar al usuario al solicitar autenticacion
            
            //Inicia la evaluacion biometrica (Face ID / Touch ID)
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in DispatchQueue.main.async { // Asegura que cualquier actualización de UI se haga en el hilo principal
                guard let self else {return}
                
                if success {
                    //Autentication exitosa
                    //Puedes continuar con acciones protegidas o mostrar datos sensibles
                    print("Biometric authentication successful")
                    self.loginTapped()
                }
                else if let error = error{
                    // Manejar fallo de autenticacion o errores
                    // Por ejemplo, mostrar un mensaje de error al usuario
                    print("Biometric authentication failed with error: \(error.localizedDescription)")
                }
                else {
                    //La autorizacion biometrica fue cancelada o falla
                    // Manejar el caso cuando el usuario cancela o falla la autenticacion
                    print("Biometric authentication was canceled or failed")
                }
            }
            }
        }
        else{
            let alert = UIAlertController(title: "Oops...", message: "You cant't use this feature", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok :(", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
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
    
    // Se ejecuta  cuando el ususario toca el boton de Face ID
    
}

