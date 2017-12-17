import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginUseCase: LoginUseCase!
    
    let dispodeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeUseCase()
        bind()
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
    }
    
    func initializeUseCase() {
        loginUseCase = LoginUseCase(with: FireBaseAuthRepository())
    }
    
    func bind() {
        loginButton.rx.tap.asDriver().drive(onNext: { [unowned self] _ in
            guard let email = self.emailTextField.text,
                let password = self.passwordTextField.text else { return }
            
            self.loginUseCase.login(with: email, and: password)
                .subscribe(onNext: { [unowned self] user in
                    if user.isEmailVerified {
                        self.toList()
                    } else {
                        self.presentValidateAlert()
                    }
                })
                .disposed(by: self.dispodeBag)
        }).disposed(by: dispodeBag)
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
