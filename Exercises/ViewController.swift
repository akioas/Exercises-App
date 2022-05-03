

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
            do {
                exercises = try context.fetch(fetchRequest)
                print(exercises)
            } catch let err as NSError {
                print(err)
            }
            tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        let tableView = UITableView()
        view.addSubview(tableView)
        setupTableView()
        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        setupButton()
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupButton(){
        let button = UIButton(frame: CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width - 80, height: 50))
        button.backgroundColor = .systemIndigo
        button.setTitle("Добавить", for: .normal)
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.frame.origin.y = -60
    }
    
    @objc func addItem(){
        DataModel().addModel()
        tableView.reloadData()
        print(exercises)
    }
    
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentEx = exercises[indexPath.row]
        
        cell.textLabel?.text = setText(item: indexPath.item, currentEx: currentEx)
        
        
        return cell
    }
    
    func setText(item: Int, currentEx: NSManagedObject) -> String{
        switch item{
        case 0:
            return caseDate(currentEx)
        case 1:
            return currentEx.value(forKey: "name") as? String ?? ""
        case 2:
            return String(currentEx.value(forKey: "rep") as? Int16 ?? 0)
        case 3:
            return String(currentEx.value(forKey: "reps") as? Int16 ?? 0)
        case 4:
            return String(currentEx.value(forKey: "weight") as? Int16 ?? 0)
        case 5:
            return String((currentEx.value(forKey: "weight") as? Int16 ?? 0) * (currentEx.value(forKey: "reps") as? Int16 ?? 0))
        
        default:
            return ""
        }
        
        
         
    }
    
    func caseDate(_ currentEx: NSManagedObject) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        let text = dateFormatter.string(from: (currentEx.value(forKey: "date") as! Date))
        return text
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 5
        }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }
}
