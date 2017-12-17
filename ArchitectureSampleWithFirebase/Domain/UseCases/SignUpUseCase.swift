import Foundation
import RxSwift

class SignUpUseCase {
    
    private let disposeBag = DisposeBag()
    
    private let authRepository: AuthRepository
    
    init(with authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func checkLogIn() -> Observable<Bool> {
        return authRepository.checkLogin()
    }
    
    func signUp(with email: String, and password: String) -> Observable<User> {
        return authRepository
            .signUp(with: email, and: password)
            .do(onNext: didSignUp)
    }
    
    private func didSignUp(_ user: User) {
        authRepository
            .sendEmailVerification()
            .subscribe(onNext: emailVerificationDidSend)
            .disposed(by: disposeBag)
    }
    
    private func emailVerificationDidSend() {

    }
}
