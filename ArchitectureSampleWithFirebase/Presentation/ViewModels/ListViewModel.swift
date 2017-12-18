import Foundation
import RxSwift
import RxCocoa

class ListViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
        let postTrigger: Driver<Void>
        let selectTrigger: Driver<Int>
        let deleteTrigger: Driver<Int>
    }
    
    struct Output {
        let load: Driver<Void>
        let posts: Driver<[Post]>
        let select: Driver<Void>
        let delete: Driver<Void>
        let toPost: Driver<Void>
    }
    
    private let listUseCase: ListUseCase
    private let navigator: ListNavigator
    
    init(with listUseCase: ListUseCase, and navigator: ListNavigator) {
        self.listUseCase = listUseCase
        self.navigator = navigator
    }
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let load = input.trigger
            .do(onNext: { [unowned self] _ in
                self.listUseCase.loadPosts()
            })
        let posts = listUseCase.contentArray.asDriver(onErrorJustReturn: [])
        let select = input.selectTrigger
            .withLatestFrom(posts) { [unowned self] (index: Int, posts: [Post]) in
                self.navigator.toPost(with: posts[index])
        }
        let delete = input.deleteTrigger
            .flatMapLatest { [unowned self] index in
                return self.listUseCase.delete(at: index)
                    .asDriver(onErrorJustReturn: ())
        }
        let toPost = input.postTrigger
            .do(onNext: { [unowned self] _ in
                self.navigator.toPost()
            })
        return ListViewModel.Output(load: load,
                                    posts: posts,
                                    select: select,
                                    delete: delete,
                                    toPost: toPost)
    }
}
