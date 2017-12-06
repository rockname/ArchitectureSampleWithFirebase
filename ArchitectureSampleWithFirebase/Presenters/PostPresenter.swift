import Firebase

class PostPresenter {
    let postModel: PostModel
    weak var view: PostViewInterface?
    
    let selectedPost: Post?
        
    init(with view: PostViewInterface, and selectedPost: Post? = nil) {
        self.view = view
        self.selectedPost = selectedPost
        self.postModel = PostModel()
        postModel.delegate = self
    }
    
    func post(_ content: String) {
        if let post = selectedPost {
            postModel.update(Post(
                id: post.id,
                user: post.user,
                content: content,
                date: Date()
            ))
        } else {
            postModel.create(with: content)
        }
    }
}

extension PostPresenter: PostModelDelegate {
    func didPost(error: Error?) {
        if let e = error {
            print("Error adding document: \(e)")
            return
        }
        print("Document added")
        view?.toList()
    }
}
