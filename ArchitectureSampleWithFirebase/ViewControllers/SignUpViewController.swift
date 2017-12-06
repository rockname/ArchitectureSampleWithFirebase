import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var authModel: AuthModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if authModel.isUserVerified() { toList() }
    }
    
    @IBAction func signUpButtonTapped() {
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        
        authModel.signUp(with: email, and: password)
    }
    @IBAction func loginButtonTapped() {
        toLogin()
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }
    
    func initializeModel() {
        authModel = AuthModel()
        authModel.delegate = self
    }
    
    func toLogin() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toLogin, sender: self)
    }
    
    func toList() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toList, sender: self)
    }
}

extension SignUpViewController: AuthModelDelegate {
    func didSignUp(newUser: User) {
        authModel.sendEmailVerification(to: newUser)
    }
    func emailVerificationDidSend() {
        toLogin()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
