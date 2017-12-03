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
    
    func read(listener: @escaping FIRQuerySnapshotBlock) -> ListenerRegistration {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        return db.collection("posts").addSnapshotListener(options: options, listener: listener)
    }
    
    func update(_ post: Post, completion: ((Error?) -> Void)?) {
        db.collection("posts").document(post.id).setData([
            "user": post.user,
            "content": post.content,
            "date": post.date
            ], completion: completion)
    }
    
    func delete(_ documentID: String) {
        db.collection("posts").document(documentID).delete()
    }
}
