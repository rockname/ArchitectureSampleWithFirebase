import Firebase

class ListPresenter {
    weak var view: ListViewInterface?
    let postModel: PostModel
    
    var contentArray: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?
    
    var listener: ListenerRegistration?
    
    init(with view: ListViewInterface) {
        self.view = view
        self.postModel = PostModel()
        postModel.delegate = self
    }
    
    func loadPosts() {
        self.listener = postModel.read()
    }
    
    func viewWillAppear() {
        selectedSnapshot = nil
    }
    
    func addButtonTapped() {
        view?.toPost()
    }
    
    func select(at index: Int) {
        selectedSnapshot = contentArray[index]
        view?.toPost()
    }
    
    func delete(at index: Int) {
        postModel.delete(contentArray[index].documentID)
        contentArray.remove(at: index)
    }
    
    private func reload(with snapshot: QuerySnapshot) {
        if !snapshot.isEmpty {
            print(snapshot)
            contentArray.removeAll()
            for item in snapshot.documents {
                contentArray.append(item)
            }
            view?.reloadData()
        }
    }
}

extension ListPresenter: PostRepositoryDelegate {
    func snapshotDidChange(snapshot: QuerySnapshot) {
        reload(with: snapshot)
    }
}
