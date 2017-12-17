import Foundation
import RxSwift

class PostUseCase {
    private let postRepository: PostRepository
    
    init(with postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func post(_ content: String) -> Observable<Void> {
        return postRepository
            .create(with: content)
    }
    
    func update(post: Post) -> Observable<Void> {
        return postRepository
            .update(post)
    }
}
