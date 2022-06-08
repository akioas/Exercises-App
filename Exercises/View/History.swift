

import UIKit
import CoreData


class History: UITableViewController{
    
    var exercises: [NSManagedObject] = []
    var names: [String] = ExercisesList().load()
    let data = GetData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        
    }
    
    func setExersises(_ exersises: [NSManagedObject]){
        self.exercises = exersises
        print(exersises)

        print(names)
    }
    
    func fetch(_ name: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseSet")

        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        
        do {
            self.exercises = try context.fetch(fetchRequest)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
            
        } catch let err as NSError {
            print(err)
        }
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.dataSource = self
        tableView.delegate = self
        let tableView = UITableView()
        view.addSubview(tableView)

        
    }
    func setupNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        
        
        let navItem = UINavigationItem(title: "")
        let backItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(back))
        
        navItem.leftBarButtonItems = [backItem]
        
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        print(navBar.frame)
    }
    @objc func back(){
        self.dismiss(animated: false)
    }
}
extension History {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
   

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        fetch(names[indexPath.row])
        let vc = Chart()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.setValues(self.exercises)
        })
        
    }
}
