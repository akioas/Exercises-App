import UIKit

class MoreInfo: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        Items().topImage(view: view, type: .common)
        let text = UILabel()
        text.frame = CGRect.init(x: 20, y: 20, width: view.frame.width, height: view.frame.height)
        text.text = NSLocalizedString("There will be magic soon", comment: "")
        text.numberOfLines = 2
        text.textColor = .black
        text.font = .systemFont(ofSize: 24)
        view.addSubview(text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

    }
}
