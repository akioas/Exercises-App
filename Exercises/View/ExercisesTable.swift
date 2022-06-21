
import UIKit
import CoreData

class ExercisesTable: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    let tableView = UITableView()

    let cellId = "cellId"
    let list = GetExercises()
    var exercises = [Exercise]()
    let items = Items()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: "fetch"),
                                               object: nil)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        items.topImage(view: view, type: .common)
        let plusButton = UIButton()
        _ = items.setupHeader(view, text: NSLocalizedString("Exercises", comment: ""), button: plusButton, imgName: "plus.circle")
        plusButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @objc func addNewEx(){
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }

    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let frame = self.view.bounds

        tableView.frame = CGRect(x: 0, y: 50 , width: frame.width, height: frame.height - 50)
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
       
    }
    
    func fetch(){
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
    
        do {
            self.exercises = try context.fetch(fetchRequest)
              
        } catch let err as NSError {
            print(err)
        }
        
    }
    @objc func refresh(){
        AppData().saveObjects()
        fetch()
        self.tableView.reloadData()
    }
    
    
    @objc func deleteObject(_ sender:Button!){
        AppData().deleteData(exercises[sender.num])
        self.refresh()
    }
    @objc func addItem(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "newex") as! NewExercise
        vc.isModalInPresentation = true

        self.present(vc, animated: true, completion: {
            vc.setObject(self.list.add(), isNewObject: true)
        })
    }
    @objc func editItem(_ sender:Button!){
        let vc = storyboard?.instantiateViewController(withIdentifier: "newex") as! NewExercise
        vc.isModalInPresentation = true

        self.present(vc, animated: true, completion: {
            vc.setObject(self.exercises[sender.num], isNewObject: false)
        })
    }
}



extension ExercisesTable {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = (exercises[indexPath.row].name ?? "") + ", " + (NSLocalizedString(exercises[indexPath.row].type ?? "", comment: ""))
        cell.backgroundColor = .secondarySystemBackground
        let deleteButton = Button(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
        deleteButton.setNum(num: indexPath.row)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .link
        deleteButton.addTarget(self, action: #selector(deleteObject), for: .touchUpInside)
        let editButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        editButton.setNum(num: indexPath.row)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .link
        editButton.addTarget(self, action: #selector(editItem(_:)), for: .touchUpInside)
        let buttons = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        buttons.addSubview(deleteButton)
        buttons.addSubview(editButton)
        cell.accessoryView = buttons
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


