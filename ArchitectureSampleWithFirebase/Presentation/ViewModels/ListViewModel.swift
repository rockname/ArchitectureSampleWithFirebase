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
        let contentArray = Variable<[Post]>([])
        let load = input.trigger
            .flatMap { [unowned self] _ in
                return self.listUseCase.loadPosts()
                    .do(onNext: { posts in
                        contentArray.value = posts
                    })
                    .map { _ in () }
                    .asDriver(onErrorJustReturn: ())
            }
        let select = input.selectTrigger
            .withLatestFrom(contentArray.asDriver()) { [unowned self] (index: Int, posts: [Post]) in
                self.navigator.toPost(with: posts[index])
        }
        let delete = input.deleteTrigger
            .flatMapLatest { [unowned self] index in
                return self.listUseCase.delete(with: contentArray.value[index].id)
                    .asDriver(onErrorJustReturn: ())
        }
        let toPost = input.postTrigger
            .do(onNext: { [unowned self] _ in
                self.navigator.toPost()
            })
        return ListViewModel.Output(load: load,
                                    posts: contentArray.asDriver(),
                                    select: select,
                                    delete: delete,
                                    toPost: toPost)
    }
}
