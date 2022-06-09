
import UIKit
import CoreData

class AddExercise: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    let tableView = UITableView()
    var object: ExerciseSet = DataModel().addModel()
    var isNewObject = true
    let cellId = "cellId"
    let data = GetData()
    let list = ExercisesList()
    var callBackStepper:((_ value:Int, _ name: String)->())?
    var callBackStepperD:((_ value:Double, _ name: String)->())?

    let datePicker = UIDatePicker()
    var blankImg = UIImage()
    var blankImgBack = UIImage()

    var plusImg = UIImage()
    var minusImg = UIImage()
    var imgSize = 0.0
//    let toolBar = UIToolbar()

    override func viewWillAppear(_ animated: Bool) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)
        let configurationLarge = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .medium)

        let configurationSmall = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        blankImg = UIImage(systemName: "rectangle.fill", withConfiguration: configuration)?.withTintColor(.clear, renderingMode: .alwaysOriginal) ?? UIImage()
        blankImgBack = UIImage(systemName: "rectangle.fill", withConfiguration: configurationLarge)?.withTintColor(.clear, renderingMode: .alwaysOriginal) ?? UIImage()
        plusImg = UIImage(systemName: "plus.square", withConfiguration: configurationSmall)?.withTintColor(.black, renderingMode: .alwaysOriginal) ?? UIImage()
        minusImg = UIImage(systemName: "minus.square", withConfiguration: configurationSmall)?.withTintColor(.black, renderingMode: .alwaysOriginal) ?? UIImage()
        blankImg.withTintColor(.clear)
        imgSize = blankImg.size.width
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: "refreshAdd"),
                                               object: nil)
        setupTableView()
        topImage(view: view, type: .common)
        setupHeader(view, text: NSLocalizedString("Add an activity", comment: ""), button: nil, imgName: nil)
        self.navigationController?.isNavigationBarHidden = true
        self.hideOnTap()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        swipeDown.delegate = self

        view.addGestureRecognizer(swipeDown)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
    }
    
    func loadObject(_ object: ExerciseSet){
        context.delete(self.object)
        self.object = object
        self.isNewObject = false
        tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.frame = CGRect(x: 0, y: 50 , width: view.frame.width, height: view.frame.height - 50)
        view.addSubview(tableView)
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let buttonCancel = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 50))
        buttonCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        buttonCancel.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        buttonCancel.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        customView.addSubview(buttonCancel)
        let buttonDone = UIButton(frame: CGRect(x: view.frame.width - 120, y: 20, width: 100, height: 50))
        buttonDone.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        buttonDone.backgroundColor = .systemGray2
        buttonDone.addTarget(self, action: #selector(done), for: .touchUpInside)
        customView.addSubview(buttonDone)
        tableView.tableFooterView = customView
    }
    
    func setupStepper(_ cell: UITableViewCell, tag: Int, value: Double, name: String, max: Double, step: Double){
        print(step)
        let stepper = Stepper()
        stepper.setBackgroundImage(blankImgBack, for: .normal)
        print(stepper.frame)

        stepper.minimumValue = 0
        stepper.maximumValue = max
        stepper.value = value
        stepper.stepValue = step
        stepper.setNum(num: tag)
        stepper.setName(name: name)
        stepper.setDividerImage(blankImg, forLeftSegmentState: .normal, rightSegmentState: .normal)
        stepper.setIncrementImage(plusImg, for: .normal)
        stepper.setDecrementImage(minusImg, for: .normal)
        stepper.transform.scaledBy(x: 2, y: 1)
        stepper.frame = CGRect(x: 0, y: 0, width: 120, height: 50)

        let label = Label()
        label.setNum(num: tag)
        label.setName(name: name)
        label.font = label.font.withSize(16)
        
        if step != 0.125{
            label.text = String( Int(stepper.value))
            stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: .valueChanged)

        } else {
            label.text = String(format: "%.2f", (stepper.value))
            stepper.addTarget(self, action: #selector(self.stepperValueChangedD(_:)), for: .valueChanged)
        }
//        cell.accessoryView?.bounds = CGRect(x: 0, y: 0, width: 120, height: 50)

        label.textAlignment = .center
        let view = UIView()
        view.frame = stepper.frame
        print(view.frame)
        label.frame = CGRect(x: (view.frame.width - imgSize) / 2, y: 0, width: imgSize, height: view.frame.height)
        view.addSubview(stepper)
        view.addSubview(label)
        cell.accessoryView = view
    }
    
    
    
    @objc func cancel(){
        if isNewObject{
            context.delete(object)
            DataModel().saveModel()
        }
        self.dismiss(animated: true)
    }
    
    
    @objc func done(){
        DataModel().saveModel()
        if object.exercise?.type == "Strength"{
            list.saveRepNum(Int(object.set_number))
            list.saveRepsNum(Int(object.repeats))
            list.saveWeightNum(object.weight)
        } else {
            list.saveCalNum(Int(object.calories))
            list.saveDurNum(Int(object.duration))
            list.saveDistNum(object.distance)
        }
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fetch"), object: self)
        })
        
    }
    
   
    @objc func showPicker(){
        
        let vc = Picker()
        vc.object = self.object
        vc.view.frame = self.view.bounds
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
         
        
//        self.present(vc, animated: false, completion: {
//            vc.setNum(0, ex: self.object)
//        })
        
    }
    
    @objc func stepperValueChanged(_ sender:Stepper!)
    {
        callBackStepper?(Int(sender.value), sender.getName())
    }
    func callBack(){
        callBackStepper = { value, name in
            self.object.setValue(value, forKey: name)
//            self.tableView.reloadData()
        }
    }
    @objc func stepperValueChangedD(_ sender:Stepper!)
    {
        callBackStepperD?((sender.value), sender.getName())
    }
    func callBackD(){
        callBackStepperD = { value, name in
            self.object.setValue(value, forKey: name)
//            self.tableView.reloadData()
        }
    }
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
    @objc func doneDate() {
        object.setValue(datePicker.date, forKey: "date")
        self.tableView.reloadData()
        cancelDate()
    }
    
    @objc func cancelDate() {
        datePicker.removeFromSuperview()
//        toolBar.removeFromSuperview()
    }
    @objc func createDatePicker(){
        
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.backgroundColor = .secondarySystemBackground
        datePicker.frame = CGRect.init(x: 0.0, y: (UIScreen.main.bounds.size.height - 300) / 2, width: UIScreen.main.bounds.size.width, height: 300)
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.contentMode = .bottom

        view.addSubview(datePicker)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        cancel()
        if let nav = navigationController {
           nav.popViewController(animated: true)
        }
    }
}



extension AddExercise {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = data.setText(item: (indexPath.item ), currentEx: object)
        if indexPath.row == 0{
            let calButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            calButton.setImage(UIImage(systemName: "calendar"), for: .normal)
            calButton.tintColor = .label
            calButton.addTarget(self, action: #selector(createDatePicker), for: .touchUpInside)
            cell.accessoryView = calButton
        } else if indexPath.row == 1{
            
            let newButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setNum(num: indexPath.section)
            newButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            newButton.tintColor = .label
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.accessoryView = newButton
            
            
        } else if indexPath.row == 2{
            if object.exercise?.type == "Strength" {
                setupStepper(cell, tag: indexPath.section, value: Double((data.getRep(currentEx: object))), name: "set_number", max: 10.0, step: 1.0)
        } else {
            setupStepper(cell, tag: indexPath.section, value: Double((data.getCal(currentEx: object))), name: "calories", max: 2000.0, step: 10.0)
        }
            callBack()
        } else if (indexPath.row == 3){
            if object.exercise?.type == "Strength" {
                setupStepper(cell, tag: indexPath.section, value: Double((data.getReps(currentEx: object))), name: "repeats", max: 100.0, step: 1.0)
            } else {
                setupStepper(cell, tag: indexPath.section, value: Double((data.getDur(currentEx: object))), name: "duration", max: 1000.0, step: 1.0)
            }
            callBack()
        } else if (indexPath.row == 4){
            if object.exercise?.type == "Strength" {
                setupStepper(cell, tag: indexPath.section, value: ((data.getWeight(currentEx: object))), name: "weight", max: 300.0, step: (0.125))
            } else {
                setupStepper(cell, tag: indexPath.section, value: ((data.getDist(currentEx: object))), name: "distance", max: 100.0, step: (0.125))
            }
            callBackD()
        } else if (indexPath.row == 5){
            cell.accessoryView = nil
        } else {
            cell.accessoryView = nil
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
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

extension AddExercise {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(AddExercise.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
//        if let _ = datePicker{
            doneDate()
//        }
    }
}
