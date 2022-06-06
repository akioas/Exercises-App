import UIKit

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window?.layer.add(transition, forKey: kCATransition)
        

        present(viewControllerToPresent, animated: false)
    }
}
