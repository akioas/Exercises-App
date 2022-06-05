import UIKit

class MoreInfo: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }
    
    override func viewDidAppear(_ animated: Bool) {
        topImage(view: view)
    }
    
    
}
