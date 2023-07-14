import UIKit

class App {
    private lazy var navigation = AppNavigation()

    func didLaunch(with window: UIWindow) {
        setupAppearence()
        navigation.setup(using: window)
    }
}
