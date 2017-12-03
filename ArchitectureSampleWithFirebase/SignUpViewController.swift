import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isUserVerified() { toList() }
    }
    
    @IBAction func signUpButtonTapped() {
        signUp()
    }
    @IBAction func loginButtonTapped() {
        toLogin()
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    func toLogin() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toLogin, sender: self)
    }

    func toList() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toList, sender: self)
    }
    
    func signUp() {
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }

            user?.sendEmailVerification() { (error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                self.toLogin()
            }
        })
    }
    
    func isUserVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
