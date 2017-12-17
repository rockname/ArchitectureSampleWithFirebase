import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    var postUseCase: PostUseCase!
    var selectedPost: Post?

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeUseCase()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let post = selectedPost {
            textField.text = post.content
        }
    }
    
    func initializeUI() {
        textField.delegate = self
    }
    
    func initializeUseCase() {
        postUseCase = PostUseCase(with: FireBasePostRepository())
    }
    
    func bind() {
        postButton.rx.tap.asDriver().drive(onNext: { [unowned self] _ in
            guard let content = self.textField.text else { return }
            if let post = self.selectedPost {
                self.postUseCase.update(post: Post(id: post.id, user: post.user, content: content, date: Date()))
                    .subscribe(onNext: { [unowned self] _ in
                        self.toList()
                    })
                    .disposed(by: self.disposeBag)
            } else {
                self.postUseCase.post(content)
                    .subscribe(onNext: { [unowned self] _ in
                        self.toList()
                    })
                    .disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
    
    func toList() {
        dismiss(animated: true)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
