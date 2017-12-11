import UIKit
import Firebase

class PostViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    
    let db = Firestore.firestore()
    
    var selectedSnapshot: DocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let snapshot = self.selectedSnapshot {
            textField.text = snapshot["content"] as? String
        }
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        if selectedSnapshot != nil {
            update()
            
        } else {
            create()
        }
    }
    
    func initializeUI() {
        textField.delegate = self
    }
    
    func create() {
        guard let text = textField.text else { return }
        
        db.collection("posts").addDocument(data: [
            "user": (Auth.auth().currentUser?.uid)!,
            "content": text,
            "date": Date()
        ]) { [unowned self] error in
            if let e = error {
                print("Error adding document: \(e)")
                return
            }
            print("Document added")
            self.dismiss(animated: true)
        }
    }
    
    func update() {
        db.collection("posts").document(selectedSnapshot!.documentID).updateData([
            "content": self.textField.text!,
            "date": Date()
        ]) { [unowned self] error in
            if let e = error {
                print("Error adding document: \(e)")
                return
            }
            print("Document updated")
            self.dismiss(animated: true)
        }
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
