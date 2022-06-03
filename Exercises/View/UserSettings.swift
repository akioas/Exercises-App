
import UIKit
import CoreData

class UserSettings: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let tableView = UITableView()
    var objects: [NSManagedObject] = []
    let cellId = "cellId"
    let data = GetData()
    let vals = UserValues()
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        setupHeader()
        botButtons()
        let newView = UIView()
        newView.frame = CGRect(x: 5.0, y: tableView.frame.maxY , width: view.frame.width - 10.0, height: 1)
        newView.backgroundColor = .lightGray
        view.addSubview(newView)
    }
    func botButtons(){
        let but1 = UIButton()
        let but2 = UIButton()
        let but3 = UIButton()
        let but4 = UIButton()
        setupBotButtons(but1, buttonNum: 1, view: view, systemName: "house.fill")
        setupBotButtons(but2, buttonNum: 2, view: view, named: "Dumbbell")
        setupBotButtons(but3, buttonNum: 3, view: view, systemName: "plus.circle")
        setupBotButtons(but4, buttonNum: 4, view: view, systemName: "gearshape.circle")
        but1.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        but2.addTarget(self, action: #selector(toExTable), for: .touchUpInside)
        but3.addTarget(self, action: #selector(addNewEx), for: .touchUpInside)
    }
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
    
        do {
            self.objects = try context.fetch(fetchRequest)
            
            
        } catch let err as NSError {
            print(err)
        }
        
    }
    @objc func cancel(){
        self.dismiss(animated: false)

    }
    @objc func addNewEx(){
        
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen

        self.present(vc, animated: false)
    }
    @objc func toExTable(){
        
        weak var pvc = self.presentingViewController

        self.dismiss(animated: false, completion: {
            let vc = ExercisesTable()
            vc.modalPresentationStyle = .fullScreen
            pvc?.present(vc, animated: false, completion: nil)
        })
        
        

    }
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let frame = self.view.bounds

        tableView.frame = CGRect(x: 0, y: 50 + topPadding, width: frame.width, height: frame.height - frame.width / 10  - topPadding  - botPadding - 54)
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
       
    }
    func setupHeader(){
        let header = UIView.init(frame: CGRect.init(x: 0, y: topPadding, width: tableView.frame.width, height: 50))
        let person = UIImageView()
        person.frame = CGRect.init(x: 10, y: 10, width: 30, height: 30)
        person.image = UIImage(systemName: "person.fill")
        let text = UILabel()
        text.frame = CGRect.init(x: 60, y: 0, width: tableView.frame.width - 120, height: 50)
        text.numberOfLines = 1
        if let object = objects.last{

            text.text = vals.getName(object)
        }
        text.textAlignment = .center
        let editButton = UIButton()
        editButton.frame = CGRect.init(x: tableView.frame.width - 50, y: 10, width: 30, height: 30)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .label
        header.backgroundColor = .secondarySystemBackground
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        view.addSubview(header)
        header.addSubview(person)
        header.addSubview(text)
        header.addSubview(editButton)
    }
    
    
    
   
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
    
   
}



extension UserSettings {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        if let object = objects.last{
            if indexPath.row == 0{
                cell.textLabel?.text = "Birthday:"
                text.text = vals.get(user: object, key: .birthday)
            } else if indexPath.row == 1{
                cell.textLabel?.text = "Weight:"
                text.text = vals.get(user: object, key: .weight)
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Sex:"
                text.text = vals.get(user: object, key: .sex)
            }
        }
        cell.accessoryView = text
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

