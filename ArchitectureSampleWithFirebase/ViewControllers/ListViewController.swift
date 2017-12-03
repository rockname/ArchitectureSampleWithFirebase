import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let postModel = PostModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        postModel.read() { error in
            self.reload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.listViewController.toPost.identifier {
            if let vc = segue.destination as? PostViewController,
                let snap = postModel.selectedSnapshot {
                vc.selectedPost = Post(
                    id: snap.documentID,
                    user: snap["user"] as! String,
                    content: snap["content"] as! String,
                    date: snap["date"] as! Date
                )
            }
        }
    }
    
    @IBAction func addButtonTapped() {
        postModel.selectedSnapshot = nil
        self.toPost()
    }
    
    func initializeTableView() {
        tableView.register(R.nib.listTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func reload() {
        if let snap = postModel.snapshot,
            !snap.isEmpty {
            print(snap)
            postModel.contentArray.removeAll()
            for item in snap.documents {
                postModel.contentArray.append(item)
            }
            self.tableView.reloadData()
        }
    }

    func toPost() {
        self.performSegue(withIdentifier: R.segue.listViewController.toPost, sender: self)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listTableViewCell.identifier) as? ListTableViewCell else { return UITableViewCell() }
        
        let content = postModel.contentArray[indexPath.row]
        let date = content["date"] as! Date
        cell.setCellData(date: date, content: String(describing: content["content"]!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postModel.selectedSnapshot = postModel.contentArray[indexPath.row]
        self.toPost()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            postModel.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
