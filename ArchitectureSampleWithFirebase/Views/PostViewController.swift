import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    var postViewModel: PostViewModel!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeViewModel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initializeUI() {
        textField.delegate = self
    }
    
    func initializeViewModel(with selectedPost: Post? = nil) {
        guard postViewModel == nil else { return }
        postViewModel = PostViewModel(with: PostModel(),
                                      and: PostNavigator(with: self),
                                      and: selectedPost)
    }
    
    func bindViewModel() {
        let input = PostViewModel.Input(postTrigger: postButton.rx.tap.asDriver(),
                                        content: textField.rx.text
                                            .map { if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: ""))
        let output = postViewModel.transform(input: input)
        output.post.drive().disposed(by: disposeBag)
        output.defaultPost.map { $0?.content }.drive(textField.rx.text).disposed(by: disposeBag)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
