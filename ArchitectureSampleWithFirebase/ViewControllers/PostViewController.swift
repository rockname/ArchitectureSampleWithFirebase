import UIKit

class PostViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    
    let postModel = PostModel()
    
    var isEditted = false
    var selectedPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let post = self.selectedPost {
            isEditted = true
            textField.text = post.content
        }
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        guard let content = textField.text else { return }
        if isEditted {
            postModel.update(Post(
                id: selectedPost.id,
                user: selectedPost.user,
                content: content,
                date: Date()
            )) { error in
                if let e = error {
                    print("Error adding document: \(e)")
                    return
                }
                print("Document added")
            }
            
        } else {
            postModel.create(with: content) { error in
                if let e = error {
                    print("Error adding document: \(e)")
                    return
                }
                print("Document updated")
            }
        }
        dismiss(animated: true)
    }
    
    func initializeUI() {
        textField.delegate = self
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
