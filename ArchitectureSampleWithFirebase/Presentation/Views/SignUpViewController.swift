import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var signUpUseCase: SignUpUseCase!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeUseCase()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    func initializeUseCase() {
        signUpUseCase = SignUpUseCase(with: FireBaseAuthRepository())
    }
    
    func bind() {
        rx.sentMessage(#selector(viewWillAppear(_:)))
            .withLatestFrom(signUpUseCase.checkLogIn()) { [unowned self] (_, isLogin) in
                if isLogin {
                    self.toList()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        signUpButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard let email = self.emailTextField.text,
                    let password = self.passwordTextField.text else { return }
                self.signUpUseCase.signUp(with: email, and: password)
                    .subscribe(onNext: { [unowned self] _ in self.toLogin() })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
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
