import Foundation
import RxSwift
import RxCocoa

class PostViewModel: ViewModelType {
    
    struct Input {
        let postTrigger: Driver<Void>
        let content: Driver<String>
    }
    
    struct Output {
        let post: Driver<Void>
        let defaultPost: Driver<Post?>
        let error: Driver<Error>
    }
    
    struct State {
        let error = ErrorTracker()
    }
    
    private let selectedPost: Post?
    private let postUseCase: PostUseCase
    private let navigator: PostNavigator
    
    init(with postUseCase: PostUseCase, and navigator: PostNavigator, and selectedPost: Post? = nil) {
        self.postUseCase = postUseCase
        self.navigator = navigator
        self.selectedPost = selectedPost
    }
    
    func transform(input: PostViewModel.Input) -> PostViewModel.Output {
        let state = State()
        let post = input.postTrigger
            .withLatestFrom(input.content)
            .flatMapLatest { [unowned self] content -> Driver<Void> in
                if let sP = self.selectedPost {
                    return self.postUseCase.update(
                        post: Post(id: sP.id,
                                   user: sP.user,
                                   content: content,
                                   date: Date()))
                        .do(onNext: { [unowned self] _ in
                            self.navigator.toList()
                        })
                        .trackError(state.error)
                        .asDriver(onErrorJustReturn: ())
                } else {
                    return self.postUseCase.post(content)
                        .do(onNext: { [unowned self] _ in
                            self.navigator.toList()
                        })
                        .trackError(state.error)
                        .asDriver(onErrorJustReturn: ())
                }
        }
        
        return PostViewModel.Output(
            post: post,
            defaultPost: Driver.just(selectedPost),
            error: state.error.asDriver()
        )
    }
}
