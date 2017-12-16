import Firebase
import RxSwift

class FireBaseAuthRepository: AuthRepository {
    
    private var signUpSubject: PublishSubject<User>!
    private var emailVerificationSubject: PublishSubject<Void>!
    private var loginSubject: PublishSubject<User>!
    
    func signUp(with email: String, and password: String) -> Observable<User> {
        signUpSubject = PublishSubject<User>()
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            if let e = error {
                print(e.localizedDescription)
                self.signUpSubject.onError(e)
                return
            }
            guard let user = user else { return }
            self.signUpSubject.onNext(User(email: user.email, isEmailVerified: user.isEmailVerified))
        }
        return signUpSubject
    }
    
    func sendEmailVerification() -> Observable<Void> {
        emailVerificationSubject = PublishSubject<Void>()
        guard let user = Auth.auth().currentUser else {
            emailVerificationSubject.onError()
            return emailVerificationSubject
        }
        user.sendEmailVerification() { [unowned self] error in
            if let e = error {
                print(e.localizedDescription)
                self.emailVerificationSubject.onError(e)
                return
            }
            self.emailVerificationSubject.onNext(())
        }
        return emailVerificationSubject
    }
    
    func login(with email: String, and password: String) -> Observable<User> {
        loginSubject = PublishSubject<User>()
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (user, error) in
            if let e = error {
                print(e.localizedDescription)
                self.loginSubject.onError(e)
                return
            }
            guard let loginUser = user else { return }
            self.loginSubject.onNext(User(email: loginUser.email, isEmailVerified: loginUser.isEmailVerified))
        }
        return loginSubject
    }
}
