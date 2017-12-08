import Foundation

@objc protocol AuthRepositoryDelegate: class {
    @objc optional func didSignUp(newUser: User)
    @objc optional func didLogIn(isEmailVerified: Bool)
    @objc optional func emailVerificationDidSend()
}

protocol AuthRepository {
    func signUp(with email: String, and password: String)
    
    func sendEmailVerification(to user: User)
    
    func login(with email: String, and password: String)
    
    func isUserVerified() -> Bool
}
