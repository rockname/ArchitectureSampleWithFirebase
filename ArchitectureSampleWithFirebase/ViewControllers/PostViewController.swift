import UIKit

class PostViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    
    var postModel: PostModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let post = postModel.selectedPost {
            textField.text = post.content
        }
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        guard let content = textField.text else { return }
        postModel.post(with: content)
        dismiss(animated: true)
    }
    
    func initializeUI() {
        textField.delegate = self
    }
    
    func initializeModel() {
        if postModel == nil {
            postModel = PostModel()
        }
        postModel.delegate = self
    }
}

extension PostViewController: PostModelDelegate {
    func didPost(error: Error?) {
        if let e = error {
            print("Error adding document: \(e)")
            return
        }
        print("Document added")
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
