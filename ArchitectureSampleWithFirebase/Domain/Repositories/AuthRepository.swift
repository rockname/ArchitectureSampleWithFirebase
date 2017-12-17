import Foundation
import RxSwift

protocol AuthRepository {
    func checkLogin() -> Observable<Bool>
    func signUp(with email: String, and password: String) -> Observable<User>
    func sendEmailVerification() -> Observable<Void>
    func login(with email: String, and password: String) -> Observable<User>
}
