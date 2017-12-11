import UIKit
import Firebase

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let db = Firestore.firestore()
    
    var contentArray: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?
    
    var listner: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        inittializeUI()
        read()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.listViewController.toPost.identifier {
            if let vc = segue.destination as? PostViewController,
                let snap = self.selectedSnapshot {
                vc.selectedSnapshot = snap
            }
        }
    }
    
    @IBAction func addButtonTapped() {
        selectedSnapshot = nil
        self.toPost()
    }
    
    func initializeTableView() {
        tableView.register(R.nib.listTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func inittializeUI() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2.0
        addButton.backgroundColor = UIColor.blue
        addButton.tintColor = UIColor.white
    }
    
    func read()  {
        let options = QueryListenOptions()
        options.includeQueryMetadataChanges(true)
        listner = db.collection("posts").order(by: "date")
            .addSnapshotListener(options: options) { [unowned self] snapshot, error in
                guard let snap = snapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                for diff in snap.documentChanges {
                    if diff.type == .added {
                        print("New data: \(diff.document.data())")
                    }
                }
                print("Current data: \(snap)")
                self.reload(with: snap)
        }
    }
    
    func delete(deleteIndexPath indexPath: IndexPath) {
        db.collection("posts").document(contentArray[indexPath.row].documentID).delete()
        contentArray.remove(at: indexPath.row)
    }
    
    func reload(with snap: QuerySnapshot) {
        if !snap.isEmpty {
            contentArray.removeAll()
            for item in snap.documents {
                contentArray.append(item)
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
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listTableViewCell.identifier) as? ListTableViewCell else { return UITableViewCell() }
        
        let content = contentArray[indexPath.row]
        let date = content["date"] as! Date
        cell.setCellData(date: date, content: String(describing: content["content"]!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSnapshot = contentArray[indexPath.row]
        self.toPost()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delete(deleteIndexPath: indexPath)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
