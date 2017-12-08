
class SignUpPresenter {
    
    let authModel: AuthModel
    weak var view: SignUpViewInterface?
    
    init(with view: SignUpViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        authModel.delegate = self
    }
    
    func viewWillAppear() {
        if authModel.isUserVerified() { view?.toList() }
    }
    
    func signUpButtonTapped() {
        guard let email = view?.email else  { return }
        guard let password = view?.password else { return }
        
        authModel.signUp(with: email, and: password)
    }
    
    func loginButtonTapped() {
        view?.toLogin()
    }
}

extension SignUpPresenter: AuthModelDelegate {
    func didSignUp(newUser: User) {
        authModel.sendEmailVerification(to: newUser)
    }
    func emailVerificationDidSend() {
        view?.toLogin()
    }
}
