import UIKit
import Firebase

class PostViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    
    let presenter = PostPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let snapshot = presenter.selectedPost {
            textField.text = snapshot["content"] as? String
        }
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        guard let content = textField.text else { return }

        presenter.post(content) { error in
            if let e = error {
                print("Error adding document: \(e)")
                return
            }
            print("Document added")
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
