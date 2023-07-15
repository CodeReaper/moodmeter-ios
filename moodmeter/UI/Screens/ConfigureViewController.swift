import UIKit
import SugarKit

class ConfigureViewController: ViewController {
    private let label = UILabel()
    private let template: Template

    private var numbers = ""

    init(navigation: AppNavigation, with template: Template) {
        self.template = template
        super.init(navigation: navigation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Translations.CONFIGURE_TITLE

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "play.fill")!,
            style: .plain,
            target: self,
            action: #selector(didTapStart)
        )

        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 120, weight: .bold)

        Stack.views(
            on: .vertical,
            distributed: .fillEqually,
            inset: NSDirectionalEdgeInsets(top: 25, leading: 15, bottom: 5, trailing: 15),
            Stack.views(label),
            Stack.views(NumPad(delegate: self))
        )
        .layout(in: view) { make, its in
            make(its.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            make(its.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
            make(its.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
            make(its.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        }
    }

    private func updateLabel() {
        label.text = repeatElement("·", count: numbers.count).joined()
    }

    @objc private func didTapStart() {
        guard
            let value = Int(numbers),
            value > 99
        else { return }

        navigation.navigate(to: .idle(in: Session(template: template, pin: value)))
    }
}

extension ConfigureViewController: NumPadEvents {
    func didTap(button: Int) {
        numbers.append("\(button)")
        updateLabel()
    }

    func didTapDelete() {
        if !numbers.isEmpty {
            numbers.removeLast()
            updateLabel()
        }
    }
}
