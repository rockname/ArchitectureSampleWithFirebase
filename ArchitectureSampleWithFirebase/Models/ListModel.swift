import Firebase

protocol ListModelDelegate: class {
    func listDidChange()
    func errorDidOccur(error: Error)
}

class ListModel {
    let db: Firestore = Firestore.firestore()
    
    var contentArray: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?
    
    var listener: ListenerRegistration?
    
    weak var delegate: ListModelDelegate?
    
    func read() {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        self.listener = db.collection("posts").order(by: "date")
            .addSnapshotListener(options: options) { [unowned self] snapshot, error in
                guard let snap = snapshot else {
                    print("Error fetching document: \(error!)")
                    self.delegate?.errorDidOccur(error: error!)
                    return
                }
                for diff in snap.documentChanges {
                    if diff.type == .added {
                        print("New data: \(diff.document.data())")
                    }
                }
                print("Current data: \(snap)")
                self.reload(with: snap)
        }
    }
    
    func delete(at index: Int) {
        db.collection("posts").document(contentArray[index].documentID).delete()
        self.contentArray.remove(at: index)
    }
    
    private func reload(with snap: QuerySnapshot) {
        if !snap.isEmpty {
            contentArray.removeAll()
            for item in snap.documents {
                contentArray.append(item)
            }
            delegate?.listDidChange()
        }
    }
}
