import UIKit

class Clock: UIViewController{
    let dateFormatter = DateFormatter()
        let locale = NSLocale.current
        var datePicker : UIDatePicker!
        let toolBar = UIToolbar()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupDatePicker()

        }

  


        func setupDatePicker(){
            let dateFormatter = DateFormatter()
                let locale = NSLocale.current
                var datePicker : UIDatePicker!
                let toolBar = UIToolbar()
//            
            datePicker = UIDatePicker()
            datePicker.frame = CGRect.init(x: 0.0, y: 50, width: UIScreen.main.bounds.size.width, height: 100)
            datePicker.backgroundColor = .white
            datePicker.datePickerMode = UIDatePicker.Mode.date
//            datePicker.center = view.center
            datePicker.contentMode = .bottom
            view.addSubview(datePicker)


            toolBar.barStyle = .default
//            toolBar.isTranslucent = true
            toolBar.sizeToFit()

            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDate))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDate))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true

           view.addSubview(toolBar)
            toolBar.sizeToFit()
        }


    @objc func doneDate() {
            let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let pickedDate = datePicker.date
        let vc = ViewController()
        self.dismiss(animated: false, completion: {
            vc.setDate(pickedDate)
            
        })


        }

    @objc func cancelDate() {
        self.dismiss(animated: false)
        }
}
