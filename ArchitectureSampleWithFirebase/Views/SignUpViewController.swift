import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var signUpViewModel: SignUpViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeViewModel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    func initializeViewModel() {
        signUpViewModel = SignUpViewModel.init(with: AuthModel(),
                                               and: SignUpNavigator(with: self))
    }
    
    func bindViewModel() {
        let input = SignUpViewModel.Input(checkLoginTrigger: rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in () }
            .asDriver(onErrorJustReturn: ()),
                                          loginTrigger: loginButton.rx.tap.asDriver(),
                                          signUpTrigger: signUpButton.rx.tap.asDriver(),
                                          email: emailTextField.rx.text
                                            .map { if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: ""),
                                          password: passwordTextField.rx.text
                                            .map { if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: "").asDriver())
        let output = signUpViewModel.transform(input: input)
        output.checkLogin.drive().disposed(by: disposeBag)
        output.login.drive().disposed(by: disposeBag)
        output.signUp.drive().disposed(by: disposeBag)
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
