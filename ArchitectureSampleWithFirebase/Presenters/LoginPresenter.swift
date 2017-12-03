import Firebase

class LoginPresenter {
    
    let authModel = AuthModel()
    
    init() {
        
    }
    
    func login(with email: String, and password: String, completion: ((User?, Error?) -> Void)?) {
        authModel.login(with: email, and: password, completion: completion)
    }
}
