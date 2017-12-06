import Firebase

protocol ListModelDelegate: class {
    func listDidChange()
}

class ListModel {
    let db: Firestore = Firestore.firestore()

    var contentArray: [DocumentSnapshot] = []
    var snapshot: QuerySnapshot?
    var selectedSnapshot: DocumentSnapshot?
    
    var listener: ListenerRegistration?

    weak var delegate: ListModelDelegate?
    
    func read() {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        self.listener = db.collection("posts").addSnapshotListener(options: options) { [unowned self] snapshot, error in
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
            self.reload()
        }
    }
    
    func delete(at index: Int) {
        db.collection("posts").document(contentArray[index].documentID).delete()
        contentArray.remove(at: index)
    }
    
    private func reload() {
        if let snap = snapshot,
            !snap.isEmpty {
            print(snap)
            contentArray.removeAll()
            for item in snap.documents {
                contentArray.append(item)
            }
            delegate?.listDidChange()
        }
    }
}
