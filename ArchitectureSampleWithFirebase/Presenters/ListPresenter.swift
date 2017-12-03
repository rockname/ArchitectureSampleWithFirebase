import Firebase

class ListPresenter {
    let postModel: PostModel
    
    var contentArray: [DocumentSnapshot] = []
    var snapshot: QuerySnapshot?
    var selectedSnapshot: DocumentSnapshot?
    
    var listener: ListenerRegistration?
    
    init() {
        self.postModel = PostModel()
    }
    
    func losdPosts(reloadCompletion: (() -> Void)?) {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        self.listener = postModel.read() { snapshot, error in
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
            self.reload(completion: reloadCompletion)
        }
    }
    
    func reload(completion: (() -> Void)?) {
        if let snap = snapshot,
            !snap.isEmpty {
            print(snap)
            contentArray.removeAll()
            for item in snap.documents {
                contentArray.append(item)
            }
            completion?()
        }
    }
    
    func select(at index: Int) {
        selectedSnapshot = contentArray[index]
    }
    
    func delete(at index: Int) {
        postModel.delete(contentArray[index].documentID)
        contentArray.remove(at: index)
    }
}
