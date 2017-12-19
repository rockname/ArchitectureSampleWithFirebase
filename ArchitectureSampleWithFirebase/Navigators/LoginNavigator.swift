import Foundation

class LoginNavigator {
    private weak var viewController: LoginViewController?
    
    init(with viewController: LoginViewController) {
        self.viewController = viewController
    }
    
    func toList() {
        viewController?.performSegue(withIdentifier: R.segue.loginViewController.toList, sender: nil)
    }
}
