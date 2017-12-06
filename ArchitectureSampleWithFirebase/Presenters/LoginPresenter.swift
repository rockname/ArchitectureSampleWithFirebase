import Firebase

class LoginPresenter {
    
    let authModel: AuthModel
    weak var view: LoginViewInterface?
    
    init(with view: LoginViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        authModel.delegate = self
    }
    
    func loginButtonTapped() {
        guard let email = view?.email else { return }
        guard let password = view?.password else { return }
        
        authModel.login(with: email, and: password)
    }
}

extension LoginPresenter: AuthModelDelegate {
    func didLogIn(isEmailVerified: Bool) {
        if isEmailVerified {
            view?.toList()
        } else {
            view?.presentValidateAlert()
        }
    }
}
