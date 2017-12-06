import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let listModel = ListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        initializeUI()
        initializeModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listModel.selectedSnapshot = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.listViewController.toPost.identifier {
            if let vc = segue.destination as? PostViewController,
                let snap = listModel.selectedSnapshot {
                let postModel = PostModel(with:
                    Post(
                        id: snap.documentID,
                        user: snap["user"] as! String,
                        content: snap["content"] as! String,
                        date: snap["date"] as! Date
                    )
                )
                vc.postModel = postModel
            }
        }
    }
    
    @IBAction func addButtonTapped() {
        self.toPost()
    }
    
    func initializeTableView() {
        tableView.register(R.nib.listTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initializeUI() {
        addButton.layer.cornerRadius = addButton.bounds.width / 2.0
        addButton.backgroundColor = UIColor.blue
        addButton.tintColor = UIColor.white
    }
    
    func initializeModel() {
        listModel.delegate = self
        listModel.read()
    }
    func toPost() {
        self.performSegue(withIdentifier: R.segue.listViewController.toPost, sender: self)
    }
}

extension ListViewController: ListModelDelegate {
    func listDidChange() {
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listTableViewCell.identifier) as? ListTableViewCell else { return UITableViewCell() }
        
        let content = listModel.contentArray[indexPath.row]
        let date = content["date"] as! Date
        cell.setCellData(date: date, content: String(describing: content["content"]!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listModel.selectedSnapshot = listModel.contentArray[indexPath.row]
        self.toPost()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listModel.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
