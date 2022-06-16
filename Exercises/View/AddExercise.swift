
import UIKit
import CoreData

class AddExercise: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let tableView = UITableView()
    var object: ExerciseSet = newExercise()
    var isNewObject = true
    let cellId = "cellId"
    let data = GetData()
    let list = GetExercises()
    var callBackStepper:((_ value:Int, _ name: String)->())?
    var callBackStepperD:((_ value:Double, _ name: String)->())?

    let datePicker = UIDatePicker()
    var blankImg = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)
    var imgSize = 0.0
    var isPicking = false
    var isWheel = false
    var header = UIView()

    var setWheel = UIPickerView()
    var calWheel = UIPickerView()
    var repsWheel = UIPickerView()
    var durWheel = UIPickerView()
    var weightWheel = UIPickerView()
    var distanceWheel = UIPickerView()
    
    let setNumData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    let rightData = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    var selected = 0
    var selectedRight = 0
    
    var transform = CATransform3DIdentity
    
    override func viewWillAppear(_ animated: Bool) {
        blankImg = UIImage(systemName: "rectangle.fill", withConfiguration: configuration)?.withTintColor(.clear, renderingMode: .alwaysOriginal) ?? UIImage()
        blankImg.withTintColor(.clear)
        imgSize = blankImg.size.width
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: "refreshAdd"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notPicking),
                                               name: NSNotification.Name(rawValue: "NotPicking"),
                                               object: nil)
      
        
        setupTableView()
        self.navigationController?.isNavigationBarHidden = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        swipeDown.delegate = self

        view.addGestureRecognizer(swipeDown)
        self.hideOnTap()

        tableView.backgroundColor = .secondarySystemBackground
        tableView.frame = CGRect(x: 0, y: 50 , width: view.frame.width, height: view.frame.height - 50)
        view.addSubview(tableView)
        topImage(view: view, type: .common)
        setupWheels()
        
        transform = CATransform3DScale(transform, 2.0, 1.5, 1.0)
        transform = CATransform3DTranslate(transform, 25, 5, 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        header = setupHeader(view, text: NSLocalizedString("Add an activity", comment: ""), button: nil, imgName: nil)
    }
    
    func loadObject(_ object: ExerciseSet){
        context.delete(self.object)
        self.object = object
        self.isNewObject = false
        header.removeFromSuperview()
        _ = setupHeader(view, text: NSLocalizedString("Edit an activity", comment: ""), button: nil, imgName: nil)
        tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    func setupStepper(_ cell: UITableViewCell, value: Double, name: String, max: Double, step: Double){
        let stepper = Stepper()
        stepperSettings(stepper: stepper, maxValue: max, step: step, img: blankImg, initValue: value, name: name)
        stepper.layer.transform = transform

        if step != 0.25{
            stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: .valueChanged)
        } else {
            stepper.addTarget(self, action: #selector(self.stepperValueChangedD(_:)), for: .valueChanged)
        }

        let view = UIView()
        view.frame = stepper.frame
        view.addSubview(stepper)
        cell.accessoryView = view
    }
    
    
    func wheelsFrame() -> CGRect{
        return CGRect(x: 52, y: 0, width: 90, height: 48)
    }
    func setupWheels(){
        setupWheelsDetailed(setWheel)
        setupWheelsDetailed(calWheel)
        setupWheelsDetailed(repsWheel)
        setupWheelsDetailed(durWheel)
        setupWheelsDetailed(weightWheel)
        setupWheelsDetailed(distanceWheel)
    }
    
    func setupWheelsDetailed(_ wheel: UIPickerView){
        wheel.delegate = self
        wheel.dataSource = self
        wheel.frame = CGRect(x: 0, y: view.frame.height - 300, width: view.frame.width, height: 300)
        wheel.backgroundColor = .systemBackground
    }
    
   
    @objc func cancel(){
        if isNewObject{
            context.delete(object)
            saveObjects()
        }
        self.dismiss(animated: true)
    }
    
    
    @objc func done(){
        saveObjects()
        if object.exercise?.type == "Strength"{
            list.saveStrength(object: object)
        } else {
            list.saveCardio(object: object)
        }
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fetch"), object: self)
        })
    }
    
   
    @objc func showPicker(){
        isPicking = true
        let vc = Picker()
        vc.object = self.object
        vc.view.frame = self.view.bounds
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    @objc func stepperValueChanged(_ sender:Stepper!)
    {
        callBackStepper?(Int(sender.value), sender.getName())
    }
    func callBack(){
        callBackStepper = { value, name in
            self.object.setValue(value, forKey: name)
            self.refresh()
        }
    }
    @objc func stepperValueChangedD(_ sender:Stepper!)
    {
        callBackStepperD?((sender.value), sender.getName())
    }
    func callBackD(){
        callBackStepperD = { value, name in
            self.object.setValue(value, forKey: name)
            self.refresh()
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
        datePicker.maximumDate = Date()
        view.addSubview(datePicker)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if !isPicking && !isWheel{
            print("f")
            cancel()
            if let nav = navigationController {
               nav.popViewController(animated: true)
            }
        }
    }
    @objc func notPicking(){
        isPicking = false
    }
   
    
}



extension AddExercise {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = data.setText(item: (indexPath.item ), currentEx: object)
        cell.selectionStyle = .none

        switch indexPath.row {
        case 0:
            cell.selectionStyle = .default
            let calButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            calButton.setImage(UIImage(systemName: "calendar", withConfiguration: configuration), for: .normal)
            calButton.tintColor = .label
            calButton.addTarget(self, action: #selector(createDatePicker), for: .touchUpInside)
            let contButton = UIButton(frame: cell.contentView.frame)
            contButton.addTarget(self, action: #selector(createDatePicker), for: .touchUpInside)
            calButton.addTarget(self, action: #selector(createDatePicker), for: .touchUpInside)
            cell.contentView.addSubview(contButton)
            view.bringSubviewToFront(contButton)
            cell.accessoryView = calButton
        case 1:
            cell.selectionStyle = .default

            let newButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setNum(num: indexPath.section)
            newButton.setImage(UIImage(systemName: "list.bullet", withConfiguration: configuration), for: .normal)
            newButton.tintColor = .label
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            let contButton = UIButton(frame: cell.contentView.frame)
            contButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.contentView.addSubview(contButton)

            cell.accessoryView = newButton

            
        case 2:
            if object.exercise?.type == "Strength" {
             
                setupStepper(cell, value: Double((data.getRep(currentEx: object))), name: "set_number", max: 10.0, step: 1.0)
                let wheelButton = UIButton(frame: wheelsFrame())
                wheelButton.addTarget(self, action:  #selector(showSetWheel), for: .touchUpInside)
                wheelButton.setTitle(String(object.set_number), for: .normal)
                wheelButton.setTitleColor(.black, for: .normal)
                cell.accessoryView!.addSubview(wheelButton)

        } else {

            setupStepper(cell, value: Double((data.getCal(currentEx: object))), name: "calories", max: 1000.0, step: 10.0)
            let wheelButton = UIButton(frame: wheelsFrame())
            wheelButton.addTarget(self, action: #selector(showCalWheel), for: .touchUpInside)
            wheelButton.setTitle(String(object.calories), for: .normal)
            wheelButton.setTitleColor(.black, for: .normal)

            cell.accessoryView!.addSubview(wheelButton)
        }
            callBack()
        case 3:

            if object.exercise?.type == "Strength" {
             
                setupStepper(cell, value: Double((data.getReps(currentEx: object))), name: "repeats", max: 100.0, step: 1.0)
                let wheelButton = UIButton(frame: wheelsFrame())
                wheelButton.addTarget(self, action: #selector(showRepsWheel), for: .touchUpInside)
                wheelButton.setTitle(String(object.repeats), for: .normal)
                wheelButton.setTitleColor(.black, for: .normal)

                cell.accessoryView!.addSubview(wheelButton)
            } else {

                setupStepper(cell, value: Double((data.getDur(currentEx: object))), name: "duration", max: 1000.0, step: 1.0)
                let wheelButton = UIButton(frame: wheelsFrame())
                wheelButton.addTarget(self, action: #selector(showDurWheel), for: .touchUpInside)
                wheelButton.setTitle(String(object.duration), for: .normal)
                wheelButton.setTitleColor(.black, for: .normal)

                cell.accessoryView!.addSubview(wheelButton)
            }
            callBack()
        case 4:

            if object.exercise?.type == "Strength" {
         
                setupStepper(cell, value: ((data.getWeight(currentEx: object))), name: "weight", max: 300.0, step: (0.25))
                let wheelButton = UIButton(frame: wheelsFrame())
                wheelButton.addTarget(self, action: #selector(showWeightWheel), for: .touchUpInside)
                wheelButton.setTitle(String(object.weight), for: .normal)
                wheelButton.setTitleColor(.black, for: .normal)

                cell.accessoryView!.addSubview(wheelButton)

            } else {

                setupStepper(cell, value: ((data.getDist(currentEx: object))), name: "distance", max: 100.0, step: (0.25))
                let wheelButton = UIButton(frame: wheelsFrame())
                wheelButton.addTarget(self, action: #selector(showDistWheel), for: .touchUpInside)
                wheelButton.setTitle(String(object.distance), for: .normal)
                wheelButton.setTitleColor(.black, for: .normal)

                cell.accessoryView!.addSubview(wheelButton)
            }
            callBackD()
        case 5:
            cell.accessoryView = nil
        default:
            cell.accessoryView = nil
        }
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            createDatePicker()
        } else if indexPath.row == 1{
            showPicker()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension AddExercise {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(AddExercise.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        

            doneDate()
        if isWheel{
            isWheel = !isWheel
            setWheel.removeFromSuperview()
            durWheel.removeFromSuperview()
            distanceWheel.removeFromSuperview()
            repsWheel.removeFromSuperview()
            weightWheel.removeFromSuperview()
            calWheel.removeFromSuperview()
        }
        refresh()

        view.endEditing(true)
        
        
    }
}

extension AddExercise{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == weightWheel || pickerView == distanceWheel{
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        setNumData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            switch pickerView{
            case setWheel:
                return String(setNumData[row])
            case calWheel:
                return String(setNumData.map { $0 * 100 }[row])
            case repsWheel:
                return String(setNumData.map { $0 * 10 }[row])
            case durWheel:
                return String(setNumData.map { $0 * 100 }[row])
            case weightWheel:
                return String(setNumData.map { $0 * 30 }[row])
            case distanceWheel:
                return String(setNumData.map { $0 * 10 }[row])
            default:
                return String(setNumData[row])
            }
        } else {
            return String(rightData[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1{
            selectedRight = rightData[row]
        } else {
            selected = row
        }
        switch pickerView{
        case setWheel:
            object.set_number = Int16((setNumData[selected]))
        case calWheel:
            object.calories = Int16(setNumData.map { $0 * 100 }[selected])
        case repsWheel:
            object.repeats = Int16(setNumData.map { $0 * 10 }[selected])
        case durWheel:
            object.duration = Int16(setNumData.map { $0 * 100 }[selected])
        case weightWheel:
            object.weight = ((setNumData.map { Double($0 * 30) }[selected]) + (Double(selectedRight) / 100.0))
        case distanceWheel:
            object.distance = ((setNumData.map { Double($0 * 10) }[selected]) + (Double(selectedRight) / 100.0))
        default:
            print("0")
        }
        refresh()
    }
}

extension AddExercise {
    @objc func showSetWheel(){
        isWheel = true
        view.addSubview(setWheel)
    }
    @objc func showCalWheel(){
        isWheel = true

        view.addSubview(calWheel)
    }
    @objc func showRepsWheel(){
        isWheel = true

        view.addSubview(repsWheel)
    }
    @objc func showDurWheel(){
        isWheel = true

        view.addSubview(durWheel)
    }
    @objc func showWeightWheel(){
        isWheel = true

        view.addSubview(weightWheel)
    }
    @objc func showDistWheel(){
        isWheel = true

        view.addSubview(distanceWheel)
    }
}
