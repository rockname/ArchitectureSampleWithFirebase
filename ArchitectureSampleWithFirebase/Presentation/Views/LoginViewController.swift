import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginViewModel: LoginViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeViewModel()
        bindViewModel()
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
    }
    
    func initializeViewModel() {
        loginViewModel = LoginViewModel(with: LoginUseCase(with: FireBaseAuthRepository()),
                                        and: LoginNavigator(with: self))
    }
    
    func bindViewModel() {
        let input = LoginViewModel.Input(loginTrigger: loginButton.rx.tap.asDriver(),
                                          email: emailTextField.rx.text
                                            .map { if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: ""),
                                          password: passwordTextField.rx.text
                                            .map { if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: "").asDriver())
        let output = loginViewModel.transform(input: input)
        output.login.drive(onNext: userWillLogin).disposed(by: disposeBag)
    }
    func userWillLogin(user: User) {
        if !user.isEmailVerified {
            presentValidateAlert()
        }
    }
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
