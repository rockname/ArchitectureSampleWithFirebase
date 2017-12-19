import Foundation

class PostNavigator {
    private weak var viewController: PostViewController?
    
    init(with viewController: PostViewController) {
        self.viewController = viewController
    }
    
    func toList() {
        viewController?.dismiss(animated: true)
    }
}
