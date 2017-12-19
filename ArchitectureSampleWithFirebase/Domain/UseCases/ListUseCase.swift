import Foundation
import RxSwift

class ListUseCase {
    
    private let postRepository: PostRepository
    
    init(with postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func loadPosts() -> Observable<[Post]> {
        return postRepository.read()
    }
    
    func delete(with id: String) -> Observable<Void> {
        return postRepository.delete(id)
    }
}

