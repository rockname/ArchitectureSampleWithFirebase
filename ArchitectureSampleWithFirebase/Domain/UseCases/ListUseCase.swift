import Foundation
import RxSwift

class ListUseCase {
    
    private let disposeBag = DisposeBag()
    
    private let postRepository: PostRepository
    
    private var _contentArray = Variable<[Post]>([])
    var contentArray: Observable<[Post]> { return _contentArray.asObservable() }
    
    init(with postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func loadPosts() {
        postRepository
            .read()
            .subscribe(onNext: postsDidLoad)
            .disposed(by: disposeBag)
    }
    
    private func postsDidLoad(_ posts: [Post]) {
        _contentArray.value = posts
    }
    
    func delete(at index: Int) -> Observable<Void> {
        return postRepository.delete(_contentArray.value[index].id)
    }
}

