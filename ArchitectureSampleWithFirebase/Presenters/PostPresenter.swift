import Firebase

class PostPresenter {
    let postModel: PostModel
    
    var selectedPost: Post?
    
    init() {
        self.postModel = PostModel()
    }
    
    func post(_ content: String, completion: ((Error?) -> Void)?) {
        if let post = selectedPost {
            postModel.update(Post(
                id: post.id,
                user: post.user,
                content: content,
                date: Date()
            ), completion: completion)
            
        } else {
            postModel.create(with: content, completion: completion)
        }
    }
}
