import Firebase

class AuthModel {
    
    init() {
        
    }
    
    func signUp(with email: String, and password: String, completion: ((User?, Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func login(with email: String, and password: String, completion: ((User?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func isUserVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
}
