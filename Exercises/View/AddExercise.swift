
import UIKit
import CoreData

class AddExercise: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate{
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
    var isPicking = false
    var header = UIView()
    let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)

    
    var setTextField = UITextField()
    var calTextField = UITextField()
    var repsTextField = UITextField()
    var durTextField = UITextField()
    var weightTextField = UITextField()
    var distanceTextField = UITextField()
    
    
    var isKeyBoard = false
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        setupTableView()
        self.navigationController?.isNavigationBarHidden = true
        self.hideOnTap()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        swipeDown.delegate = self

        view.addGestureRecognizer(swipeDown)
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.frame = CGRect(x: 0, y: 50 , width: view.frame.width, height: view.frame.height - 50)
        view.addSubview(tableView)
        topImage(view: view, type: .common)

    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()

        header = setupHeader(view, text: NSLocalizedString("Add an activity", comment: ""), button: nil, imgName: nil)
        textFields()
    }
    
    func loadObject(_ object: ExerciseSet){
        context.delete(self.object)
        self.object = object
        self.isNewObject = false
        header.removeFromSuperview()
        setupHeader(view, text: NSLocalizedString("Edit an activity", comment: ""), button: nil, imgName: nil)
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
    
    func setupStepper(_ cell: UITableViewCell, tag: Int, value: Double, name: String, max: Double, step: Double){
        print(step)
        let stepper = Stepper()
//        stepper.setBackgroundImage(blankImgBack, for: .normal)
        print(stepper.frame)

        stepper.minimumValue = 0
        stepper.maximumValue = max
        stepper.value = value
        stepper.stepValue = step
        stepper.setNum(num: tag)
        stepper.setName(name: name)
        stepper.setDividerImage(blankImg, forLeftSegmentState: .normal, rightSegmentState: .normal)
//        stepper.setIncrementImage(plusImg, for: .normal)
//        stepper.setDecrementImage(minusImg, for: .normal)
//        stepper.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, 2.0, 1.5, 1.0)
        transform = CATransform3DTranslate(transform, 25, 5, 0)
        stepper.layer.transform = transform
//        stepper.transform = CGAffineTransform(scaleX: 1.55, y: 1.5)
        print(view.frame.width)

        let label = Label()
        label.setNum(num: tag)
        label.setName(name: name)
        label.font = label.font.withSize(16)
        
        if step != 0.25{
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
//        view.addSubview(label)
        cell.accessoryView = view
    }
    
    func textFields(){
        setupTextField(setTextField)
        setupTextField(repsTextField)
        setupTextField(weightTextField)
        setupTextField(calTextField)
        setupTextField(distanceTextField)
        setupTextField(durTextField)
        fieldsFrame()
        
        setTextField.textColor = .label
        repsTextField.textColor = .label
        weightTextField.textColor = .label
        
        calTextField.textColor = .label
        durTextField.textColor = .label
        distanceTextField.textColor = .label

    }
    func fieldsFrame(){
        let frame = CGRect(x: 52, y: 0, width: 90, height: 48)
        setTextField.frame = frame
        repsTextField.frame = frame
        weightTextField.frame = frame
        calTextField.frame = frame
        distanceTextField.frame = frame
        durTextField.frame = frame

    }
    func setupTextField(_ textField: UITextField){
        textField.delegate = self
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = true
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.bringSubviewToFront(textField)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("1111")
        print(object.set_number)
        switch textField{
        case setTextField:
            object.set_number = Int16(textField.text ?? "") ?? 0
        case repsTextField:
            object.repeats = Int16(textField.text ?? "") ?? 0
        case weightTextField:
            object.weight = Double(textField.text ?? "") ?? 0.0
        case durTextField:
            object.duration = Int16(textField.text ?? "") ?? 0
        case calTextField:
            object.calories = Int16(textField.text ?? "") ?? 0
        case distanceTextField:
            object.distance = Double(textField.text ?? "") ?? 0.0
        default:
            print("error")
        }
        print(object.set_number)
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
        isPicking = true
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
        if !isPicking{
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
//        fieldsFrame(cell)
        switch indexPath.row {
        case 0:
            let calButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            calButton.setImage(UIImage(systemName: "calendar", withConfiguration: configuration), for: .normal)
            calButton.tintColor = .label
            calButton.addTarget(self, action: #selector(createDatePicker), for: .touchUpInside)
            cell.accessoryView = calButton
        case 1:
            let newButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setNum(num: indexPath.section)
            newButton.setImage(UIImage(systemName: "list.bullet", withConfiguration: configuration), for: .normal)
            newButton.tintColor = .label
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.accessoryView = newButton
            
            
        case 2:
            if object.exercise?.type == "Strength" {
                
                calTextField.isHidden = true
                setTextField.isHidden = false
//                cell.textLabel?.text = ""
//                setTextField.becomeFirstResponder()
                setupStepper(cell, tag: indexPath.section, value: Double((data.getRep(currentEx: object))), name: "set_number", max: 10.0, step: 1.0)
                setTextField.text = String(object.set_number)
                
                cell.accessoryView!.addSubview(setTextField)

        } else {
//            cell.contentView.addSubview(calTextField)
            setTextField.isHidden = true
            calTextField.isHidden = false

            setupStepper(cell, tag: indexPath.section, value: Double((data.getCal(currentEx: object))), name: "calories", max: 2000.0, step: 10.0)
            cell.accessoryView?.addSubview(calTextField)
            
            
            calTextField.text = String(object.calories)
            
        }
            callBack()
        case 3:

            if object.exercise?.type == "Strength" {
//                cell.contentView.addSubview(repsTextField)
                durTextField.isHidden = true
                repsTextField.isHidden = false

                setupStepper(cell, tag: indexPath.section, value: Double((data.getReps(currentEx: object))), name: "repeats", max: 100.0, step: 1.0)
                cell.accessoryView?.addSubview(repsTextField)
                repsTextField.text = String(object.repeats)
                
            } else {
//                cell.contentView.addSubview(durTextField)
                repsTextField.isHidden = true
                durTextField.isHidden = false

                setupStepper(cell, tag: indexPath.section, value: Double((data.getDur(currentEx: object))), name: "duration", max: 1000.0, step: 1.0)
                cell.accessoryView?.addSubview(durTextField)
                durTextField.text = String(object.duration)
            }
            callBack()
        case 4:

            if object.exercise?.type == "Strength" {
//                cell.contentView.addSubview(weightTextField)
                distanceTextField.isHidden = true
                weightTextField.isHidden = false

                setupStepper(cell, tag: indexPath.section, value: ((data.getWeight(currentEx: object))), name: "weight", max: 300.0, step: (0.25))
                cell.accessoryView?.addSubview(weightTextField)
                weightTextField.text = String(object.weight)
            } else {
//                cell.contentView.addSubview(distanceTextField)
                weightTextField.isHidden = true
                distanceTextField.isHidden = false

                setupStepper(cell, tag: indexPath.section, value: ((data.getDist(currentEx: object))), name: "distance", max: 100.0, step: (0.25))
                cell.accessoryView?.addSubview(distanceTextField)
                distanceTextField.text = String(object.distance)

            }
            callBackD()
        case 5:
            cell.accessoryView = nil
        default:
            cell.accessoryView = nil
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 2{
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
        /*
        if !isKeyBoard{
            doneDate()
        } else {
            object.set_number = Int16(setTextField.text ?? "") ?? 0
            object.repeats = Int16(repsTextField.text ?? "") ?? 0
            object.weight = Double(weightTextField.text ?? "") ?? 0.0
            object.duration = Int16(durTextField.text ?? "") ?? 0
            object.calories = Int16(calTextField.text ?? "") ?? 0
            object.distance = Double(distanceTextField.text ?? "") ?? 0.0
            refresh()
        }
         
*/
        if !isKeyBoard{
            doneDate()
//
        }
        refresh()

        view.endEditing(true)

    }
}
 
extension AddExercise {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setValue(textField)
        refresh()
        textField.resignFirstResponder()
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == weightTextField || textField == distanceTextField{
            if (textField.text)?.filter({ $0 == "." }).count ?? 0 > 0{
//                return AllowedText().textDigits(string: string)
                return AllowedText().textDigits(string: string)
            }
            if string == "," {
                             textField.text = textField.text! + "."
                             return false
                         }
            
               return AllowedText().textDigitsDot(string: string)
        } else {
            return AllowedText().textDigits(string: string)

        }
        
        }
    
    @objc func keyboardWillAppear() {
        isKeyBoard = true
        print(isKeyBoard)
        
        
    }

    @objc func keyboardWillDisappear() {
        print("L")
        /*
        setTextField.textColor = .clear
        repsTextField.textColor = .clear
        weightTextField.textColor = .clear
        
        calTextField.textColor = .clear
        durTextField.textColor = .clear
        distanceTextField.textColor = .clear
         */
        isKeyBoard = false
        refresh()


        /*
        object.set_number = Int16(setTextField.text ?? "") ?? 0
        object.repeats = Int16(repsTextField.text ?? "") ?? 0
        object.weight = Double(weightTextField.text ?? "") ?? 0.0
        object.duration = Int16(durTextField.text ?? "") ?? 0
        object.calories = Int16(calTextField.text ?? "") ?? 0
        object.distance = Double(distanceTextField.text ?? "") ?? 0.0
        print(object.repeats)
        print(setTextField.text)
        setTextField.text = ""
        repsTextField.text = ""
        weightTextField.text = ""
        
        calTextField.text = ""
        durTextField.text = ""
        distanceTextField.text = ""
        isKeyBoard = false
        print(object.repeats)
        refresh()
*/
    }
    
    func setValue(_ textField: UITextField){
        switch textField{
        case setTextField:
            object.set_number = Int16(textField.text ?? "") ?? 0
        case repsTextField:
            object.repeats = Int16(textField.text ?? "") ?? 0
        case weightTextField:
            object.weight = Double(textField.text ?? "") ?? 0.0
        case durTextField:
            object.duration = Int16(textField.text ?? "") ?? 0
        case calTextField:
            object.calories = Int16(textField.text ?? "") ?? 0
        case distanceTextField:
            object.distance = Double(textField.text ?? "") ?? 0.0
        default:
            print("error")
        }
     
    }
     
    
}
