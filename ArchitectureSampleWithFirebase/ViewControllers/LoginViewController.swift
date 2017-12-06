import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var authModel = AuthModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeModel()
    }
    
    @IBAction func loginButtonTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        authModel.login(with: email, and: password)
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
    }
    func initializeModel() {
        authModel = AuthModel()
        authModel.delegate = self
    }
    
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func toList()  {
        self.performSegue(withIdentifier: R.segue.loginViewController.toList, sender: self)
    }
}

extension LoginViewController: AuthModelDelegate {
    func didLogIn(isEmailVerified: Bool) {
        if isEmailVerified {
            self.toList()
        } else {
            self.presentValidateAlert()
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
