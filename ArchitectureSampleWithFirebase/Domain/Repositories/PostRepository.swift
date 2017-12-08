import Foundation

protocol PostRepositoryDelegate: class {
    func didPost(error: Error?)
    func postsDidChange(posts: [Post])
}

protocol PostRepository {
    var delegate: PostRepositoryDelegate? { get set }
    func create(with content: String)
    func read()
    func update(_ post: Post)
    func delete(_ documentID: String)
}
