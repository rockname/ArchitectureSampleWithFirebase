import Foundation
import RxSwift

protocol PostRepository {
    func create(with content: String) -> Observable<Post>
    func read() -> Observable<[Post]>
    func update(_ post: Post) -> Observable<Post>
    func delete(_ postId: String) -> Observable<Void>
}
