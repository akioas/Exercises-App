

import UIKit


class FirstLaunch: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

    }
    @IBOutlet weak var texts: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        
        setup()
    }
    
    func setup(){
        view.frame = CGRect.init(x: 0, y: -view.safeAreaInsets.top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
        let height = self.view.safeAreaLayoutGuide.layoutFrame.height
        let nextBConstraint = NSLayoutConstraint(item: texts!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: height )
        NSLayoutConstraint.activate([nextBConstraint])
        print(nextButton.frame)
        if view.frame.height < 660{
            texts.spacing = 0
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(FirstLaunch.tapped))
        logo.addGestureRecognizer(tap)
        logo.isUserInteractionEnabled = true
    }
    
    
    @objc func tapped(tapGestureRecognizer: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "firstlaunchtext") as! FirstLaunchText
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
