import UIKit

protocol SignUpViewInterface: class {
    var email: String? { get }
    var password: String? { get }
    func toList()
    func toLogin()
}

class SignUpViewController: UIViewController, SignUpViewInterface {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var presenter: SignUpPresenter!
    
    var email: String? {
        return self.emailTextField.text
    }
    var password: String? {
        return self.passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializePresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    @IBAction func signUpButtonTapped() {
        presenter.signUpButtonTapped()
    }
    @IBAction func loginButtonTapped() {
        presenter.loginButtonTapped()
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    func initializePresenter() {
        presenter = SignUpPresenter(with: self)
    }
    
    func toLogin() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toLogin, sender: self)
    }

    func toList() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toList, sender: self)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
