

import UIKit


class FirstLaunch: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var texts: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        
        setup()
    }
         
    func setup(){
        view.frame = CGRect.init(x: 0, y: -view.safeAreaInsets.top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

//        StartText().setBotButtonText(button: nextButton, text: ">")
        
        let height = self.view.safeAreaLayoutGuide.layoutFrame.height
        let nextBConstraint = NSLayoutConstraint(item: texts!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: height )
        NSLayoutConstraint.activate([ nextBConstraint])
        print(nextButton.frame)
        
    }
}
