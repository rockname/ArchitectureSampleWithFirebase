import Firebase

@objc protocol AuthModelDelegate: class {
    @objc optional func didSignUp(newUser: User)
    @objc optional func didLogIn(isEmailVerified: Bool)
    @objc optional func emailVerificationDidSend()
}

class AuthModel {
    weak var delegate: AuthModelDelegate?
    
    func signUp(with email: String, and password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let user = user else { return }
            self.delegate?.didSignUp?(newUser: user)
        }
    }
    func sendEmailVerification(to user: User) {
        user.sendEmailVerification() { [unowned self] error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            self.delegate?.emailVerificationDidSend?()
        }
    }
    func login(with email: String, and password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (user, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let loginUser = user else { return }
            self.delegate?.didLogIn?(isEmailVerified: loginUser.isEmailVerified)
        }
    }
    
    func isUserVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
}
