import Foundation
import Firebase

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}

protocol PostModelDelegate: class {
    func didPost(error: Error?)
}
class PostModel {
    
    let db: Firestore
    
    let selectedPost: Post?
    
    var delegate: PostModelDelegate?
    
    init(with selectedPost: Post? = nil) {
        self.selectedPost = selectedPost
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
    }
    
    func post(with content: String) {
        if let post = selectedPost {
            db.collection("posts").document(post.id).updateData([
                "content": post.content,
                "date": post.date
            ]) { [unowned self] error in
                self.delegate?.didPost(error: error)
            }
        } else {
            db.collection("posts").addDocument(data: [
                "user": (Auth.auth().currentUser?.uid)!,
                "content": content,
                "date": Date()
            ]) { [unowned self] error in
                self.delegate?.didPost(error: error)
            }
        }
    }
}
