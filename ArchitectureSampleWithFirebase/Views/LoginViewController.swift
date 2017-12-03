import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let presenter = LoginPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    @IBAction func loginButtonTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        presenter.login(with: email, and: password) { (user, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            guard let loginUser = user else { return }
            
            if loginUser.isEmailVerified {
                self.toList()
            } else {
                self.presentValidateAlert()
            }
        }
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
