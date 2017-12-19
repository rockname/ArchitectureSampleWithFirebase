import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var listUseCase: ListUseCase!
    let disposeBag = DisposeBag()
    
    var selectedPost: Post?
    let contentArray = ArrayTracker<Post>()
    let error = ErrorTracker()
    let isLoading = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        initializeUI()
        initializeUseCase()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedPost = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.listViewController.toPost.identifier {
            if let vc = segue.destination as? PostViewController,
                let post = selectedPost {
                vc.selectedPost = post
            }
        }
    }
    
    func initializeTableView() {
        tableView.register(R.nib.listTableViewCell)
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initializeUI() {
        addButton.layer.cornerRadius = addButton.bounds.width / 2.0
        addButton.backgroundColor = UIColor.blue
        addButton.tintColor = UIColor.white
    }
    
    func initializeUseCase() {
        listUseCase = ListUseCase(with: FireBasePostRepository())
    }
    
    func bind() {
        addButton.rx.tap.asDriver().drive(onNext: toPost).disposed(by: disposeBag)
        listUseCase.loadPosts()
            .trackError(error)
            .trackActivity(isLoading)
            .trackArray(contentArray)
            .asDriver(onErrorJustReturn: [])
            .drive()
            .disposed(by: disposeBag)
        contentArray.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.listTableViewCell.identifier, cellType: ListTableViewCell.self)) { (row, element, cell) in
                cell.setCellData(date: element.date, content: element.content)
            }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected.asDriver()
            .withLatestFrom(contentArray.asDriver()) { [unowned self] (indexPath: IndexPath, posts: [Post]) in
                self.selectedPost = posts[indexPath.row]
                self.toPost()
            }
            .drive()
            .disposed(by: disposeBag)
        tableView.rx.itemDeleted.asDriver()
            .drive(onNext: { [unowned self] indexPath in
                self.listUseCase.delete(with: self.contentArray.array[indexPath.row].id)
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func toPost() {
        self.performSegue(withIdentifier: R.segue.listViewController.toPost, sender: self)
    }
}
