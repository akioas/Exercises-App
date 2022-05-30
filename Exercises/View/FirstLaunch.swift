

import UIKit


class FirstLaunch: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        if UserVariables().isFirstLaunch(){ //!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        
        let nextBConstraint = NSLayoutConstraint(item: nextButton!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: self.view.bounds.height * 0.95)
        let logoConstraint = NSLayoutConstraint(item: logo!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.view.bounds.height * 0.05)
        NSLayoutConstraint.activate([logoConstraint, nextBConstraint])
         
    }
         
}
