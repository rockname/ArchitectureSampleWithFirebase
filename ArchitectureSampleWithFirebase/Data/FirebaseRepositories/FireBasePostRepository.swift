import Firebase

class FireBasePostRepository: PostRepository {
    
    let db: Firestore
    
    var delegate: PostRepositoryDelegate?
    
    var listener: ListenerRegistration?

    init() {
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
    }
    
    func create(with content: String) {
        db.collection("posts").addDocument(data: [
            "user": (Auth.auth().currentUser?.uid)!,
            "content": content,
            "date": Date()
        ]) { [unowned self] error in
            self.delegate?.didPost?(error: error)
        }
    }
    
    func read() {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        listener = db.collection("posts").addSnapshotListener(options: options) { snapshot, error in
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
            self.delegate?.snapshotDidChange?(snapshot: snap)
        }
    }
    
    func update(_ post: Post) {
        db.collection("posts").document(post.id).setData([
            "user": post.user,
            "content": post.content,
            "date": post.date
        ]) { [unowned self] error in
            self.delegate?.didPost?(error: error)
        }
    }
    
    func delete(_ documentID: String) {
        db.collection("posts").document(documentID).delete()
    }
}
