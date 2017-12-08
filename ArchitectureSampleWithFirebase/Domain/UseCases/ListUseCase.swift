import Foundation

class ListUseCase {
    weak var view: ListViewInterface?
    let postRepository: PostRepository
    
    var contentArray: [Post] = []
    var selectedPost: Post?
    
    init(with view: ListViewInterface) {
        self.view = view
        self.postRepository = FireBasePostRepository()
        postRepository.delegate = self
    }
    
    func loadPosts() {
        postRepository.read()
    }
    
    func viewWillAppear() {
        selectedPost = nil
    }
    
    func addButtonTapped() {
        view?.toPost()
    }
    
    func select(at index: Int) {
        selectedPost = contentArray[index]
        view?.toPost()
    }
    
    func delete(at index: Int) {
        postRepository.delete(contentArray[index].id)
        contentArray.remove(at: index)
    }
    
    private func reload(with posts: [Post]) {
        if !posts.isEmpty {
            print(posts)
            contentArray = posts
            view?.reloadData()
        }
    }
}

extension ListPresenter: PostRepositoryDelegate {
    func postsDidChange(posts: [Post]) {
        reload(with: posts)
    }
}

