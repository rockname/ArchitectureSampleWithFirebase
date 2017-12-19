import Foundation
import RxSwift
import RxCocoa
import Firebase

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
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    struct State {
        let contentArray = ArrayTracker<Post>()
        let isLoading = ActivityIndicator()
        let error = ErrorTracker()
    }
    
    private let postModel: PostModel
    private let navigator: ListNavigator
    
    init(with postModel: PostModel, and navigator: ListNavigator) {
        self.postModel = postModel
        self.navigator = navigator
    }
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let state = State()
        let load = input.trigger
            .flatMap { [unowned self] _ in
                return self.postModel.read()
                    .map { snap in
                        var posts: [Post] = []
                        if !snap.isEmpty {
                            for item in snap.documents {
                                posts.append(Post(id: item.documentID,
                                                  user: item["user"] as! String,
                                                  content: item["content"] as! String,
                                                  date: item["date"] as! Date)
                                )
                            }
                        }
                        return posts
                    }
                    .trackArray(state.contentArray)
                    .trackError(state.error)
                    .trackActivity(state.isLoading)
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            }
        let select = input.selectTrigger
            .withLatestFrom(state.contentArray) { [unowned self] (index: Int, posts: [Post]) in
                self.navigator.toPost(with: posts[index])
        }
        let delete = input.deleteTrigger
            .flatMapLatest { [unowned self] index in
                return self.postModel.delete(state.contentArray.array[index].id)
                    .asDriver(onErrorJustReturn: ())
        }
        let toPost = input.postTrigger
            .do(onNext: { [unowned self] _ in
                self.navigator.toPost()
            })
        return ListViewModel.Output(load: load,
                                    posts: state.contentArray.asDriver(),
                                    select: select,
                                    delete: delete,
                                    toPost: toPost,
                                    isLoading: state.isLoading.asDriver(),
                                    error: state.error.asDriver())
    }
}
