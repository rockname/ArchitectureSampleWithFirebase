import UIKit
import Firebase

protocol LoginViewInterface: class {
    var email: String? { get }
    var password: String? { get }
    func toList()
    func presentValidateAlert()
}

class LoginViewController: UIViewController, LoginViewInterface {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var presenter: LoginPresenter!
    
    var email: String? {
        return emailTextField.text
    }
    var password: String? {
        return passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializePresenter()
    }
    
    @IBAction func loginButtonTapped() {
        presenter.loginButtonTapped()
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
    }
    
    func initializePresenter() {
        presenter = LoginPresenter(with: self)
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
