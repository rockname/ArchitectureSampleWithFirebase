import Foundation
import Firebase

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}

class PostModel {
    
    let db = Firestore.firestore()

    init() {
        
    }
    
    func create(with content: String, completion: ((Error?) -> Void)?) {
        db.collection("posts").addDocument(data: [
            "user": (Auth.auth().currentUser?.uid)!,
            "content": content,
            "date": Date()
            ], completion: completion)
    }
    
    func update(_ post: Post, completion: ((Error?) -> Void)?) {
        db.collection("posts").document(post.id).setData([
            "user": post.user,
            "content": post.content,
            "date": post.date
        ], completion: completion)
    }
}
