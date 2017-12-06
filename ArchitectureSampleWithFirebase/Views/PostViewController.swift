import UIKit
import Firebase

protocol PostViewInterface: class {
    func toList()
}

class PostViewController: UIViewController, PostViewInterface {
    
    @IBOutlet var textField: UITextField!
    
    var presenter: PostPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializePresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let post = presenter.selectedPost {
            textField.text = post.content
        }
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        guard let content = textField.text else { return }

        presenter.post(content)
    }
    
    func initializeUI() {
        textField.delegate = self
    }
    
    func initializePresenter() {
        if presenter == nil { presenter = PostPresenter(with: self) }
    }
    
    func toList() {
        dismiss(animated: true)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
