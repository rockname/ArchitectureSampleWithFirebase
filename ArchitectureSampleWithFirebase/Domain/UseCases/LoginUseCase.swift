import Foundation
import RxSwift

class LoginUseCase {
    
    private let authRepository: AuthRepository
    
    init(with authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func login(with email: String, and password: String) -> Observable<User> {
        return authRepository.login(with: email, and: password)
    }
}
