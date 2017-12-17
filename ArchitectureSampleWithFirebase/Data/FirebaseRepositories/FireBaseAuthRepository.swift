import Firebase
import RxSwift

class FireBaseAuthRepository: AuthRepository {
    
    func signUp(with email: String, and password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                guard let user = user else { return }
                observer.onNext(User(email: user.email, isEmailVerified: user.isEmailVerified))
            }
            return Disposables.create()
        }
    }
    
    func sendEmailVerification() -> Observable<Void> {
        return Observable.create { observer in
            guard let user = Auth.auth().currentUser else {
                observer.onError(Exception.auth)
                return Disposables.create()
            }
            user.sendEmailVerification() { error in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func login(with email: String, and password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                guard let loginUser = user else {
                    observer.onError(Exception.auth)
                    return
                }
                observer.onNext(User(email: loginUser.email, isEmailVerified: loginUser.isEmailVerified))
            }
            return Disposables.create()
        }
    }
}
