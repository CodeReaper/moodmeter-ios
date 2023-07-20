import UIKit

indirect enum Navigation {
    case setup
    case editor(with: Editable)
    case configure(with: Template)
    case idle(in: Session)
    case vote(in: Session)
    case results(in: Session)
    case endSession
    case licenses
    case license(title: String, content: String)
}

class AppNavigation {
    private var navigationController = UINavigationController()
    private var sessionNavigationController = UINavigationController()

    private var window: UIWindow?

    private let templates = Storage<Template>(tag: "template")

    func setup(using window: UIWindow) {
        self.window = window

        navigate(to: .setup)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func navigate(to endpoint: Navigation) {
        guard let window = window else {
            return
        }

        switch endpoint {
        case .setup:
            navigationController.setViewControllers([SetupViewController(navigation: self, templates: templates)], animated: false)
        case .editor(let template):
            navigationController.pushViewController(EditorViewController(navigation: self, with: template), animated: true)
        case .configure(let template):
            navigationController.pushViewController(ConfigureViewController(navigation: self, with: template), animated: true)
        case .idle(let session):
            sessionNavigationController.setViewControllers([IdleViewController(navigation: self, with: session)], animated: false)
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight) {
                window.rootViewController = self.sessionNavigationController
                window.makeKeyAndVisible()
            } completion: { _ in
                self.navigationController.popToRootViewController(animated: false)
            }
        case .vote(let session):
            sessionNavigationController.pushViewController(VoteViewController(navigation: self, with: session), animated: true)
        case .results(let session):
            sessionNavigationController.pushViewController(ResultsViewController(navigation: self, with: session), animated: true)
        case .endSession:
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight) {
                window.rootViewController = self.navigationController
                window.makeKeyAndVisible()
            } completion: { _ in
                self.sessionNavigationController.setViewControllers([], animated: false)
            }
        case .licenses:
            navigationController.pushViewController(LicensesViewController(navigation: self), animated: true)
        case let .license(title, content):
            navigationController.pushViewController(LicenseViewController(navigation: self, title: title, content: content), animated: true)
        }
    }
}
