import Firebase

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}
@objc protocol PostModelDelegate: class {
    @objc optional func didPost(error: Error?)
    @objc optional func snapshotDidChange(snapshot: QuerySnapshot)
}
class PostModel {
    
    let db: Firestore
    
    weak var delegate: PostModelDelegate?

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
    
    func read() -> ListenerRegistration {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        return db.collection("posts").order(by: "date")
            .addSnapshotListener(options: options) { snapshot, error in
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
