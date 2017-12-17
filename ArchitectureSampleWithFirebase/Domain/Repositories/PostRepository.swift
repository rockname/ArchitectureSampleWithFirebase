import Foundation
import RxSwift

protocol PostRepository {
    func create(with content: String) -> Observable<Void>
    func read() -> Observable<[Post]>
    func update(_ post: Post) -> Observable<Void>
    func delete(_ postId: String) -> Observable<Void>
}
