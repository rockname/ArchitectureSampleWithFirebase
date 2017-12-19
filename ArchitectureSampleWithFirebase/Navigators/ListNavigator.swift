import Foundation

class ListNavigator {
    private weak var viewController: ListViewController?
    
    init(with viewController: ListViewController) {
        self.viewController = viewController
    }
    
    func toPost(with selectedPost: Post? = nil) {
        viewController?.performSegue(withIdentifier: R.segue.listViewController.toPost.identifier, sender: selectedPost)
    }
}
