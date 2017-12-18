import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var listViewModel: ListViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        initializeUI()
        initializeViewModel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.listViewController.toPost.identifier {
            if let vc = segue.destination as? PostViewController,
                let post = sender as? Post {
                vc.initializeViewModel(with: post)
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
    
    func initializeViewModel() {
        listViewModel = ListViewModel(
            with: ListUseCase(with: FireBasePostRepository()),
            and: ListNavigator(with: self)
        )
    }
    
    func bindViewModel() {
        
        let input = ListViewModel.Input(trigger: Driver.just(()),
                                        postTrigger: addButton.rx.tap.asDriver(),
                                        selectTrigger: tableView.rx.itemSelected.asDriver().map { $0.row },
                                        deleteTrigger: tableView.rx.itemDeleted.asDriver().map { $0.row })
        let output = listViewModel.transform(input: input)
        
        output.posts
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.listTableViewCell.identifier, cellType: ListTableViewCell.self)) { (row, element, cell) in
                cell.setCellData(date: element.date, content: element.content)
            }
            .disposed(by: disposeBag)
        output.load.drive().disposed(by: disposeBag)
        output.select.drive().disposed(by: disposeBag)
        output.delete.drive().disposed(by: disposeBag)
        output.toPost.drive().disposed(by: disposeBag)
    }
}
