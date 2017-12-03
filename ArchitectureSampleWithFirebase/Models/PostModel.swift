import Foundation
import Firebase

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}

class PostModel {
    
    let db: Firestore
    
    var contentArray: [DocumentSnapshot] = []
    var snapshot: QuerySnapshot?
    var selectedSnapshot: DocumentSnapshot?
    
    var listener: ListenerRegistration?
    
    init() {
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
    }
    
    func create(with content: String, completion: ((Error?) -> Void)?) {
        db.collection("posts").addDocument(data: [
            "user": (Auth.auth().currentUser?.uid)!,
            "content": content,
            "date": Date()
            ], completion: completion)
    }
    
    func read(listener: ((Error?) -> Void)?) {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        self.listener = db.collection("posts").addSnapshotListener(options: options) { snapshot, error in
            guard let snap = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            for diff in snap.documentChanges {
                if diff.type == .added {
                    print("New data: \(diff.document.data())")
                }
            }
            print("Current data: \(snap)")
            self.snapshot = snap
            
            listener?(error)
        }
    }

    func update(_ post: Post, completion: ((Error?) -> Void)?) {
        db.collection("posts").document(post.id).setData([
            "user": post.user,
            "content": post.content,
            "date": post.date
            ], completion: completion)
    }

    func delete(at index: Int) {
        db.collection("posts").document(contentArray[index].documentID).delete()
        contentArray.remove(at: index)
    }
}
