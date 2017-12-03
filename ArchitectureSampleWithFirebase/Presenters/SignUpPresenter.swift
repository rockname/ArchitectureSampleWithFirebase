import Firebase

class SignUpPresenter {
    
    let authModel = AuthModel()
    
    var isUserVerified: Bool = {
        return self.authModel.isUserVerified()
    }
    
    init() {
        
    }
    
    func signUp(with email: String, and password: String, completion: ((User?, Error?) -> Void)?) {
        authModel.signUp(with: email, and: password, completion: completion)
    }
}
