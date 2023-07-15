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

    override func viewDidLoad() { // swiftlint:disable:this function_body_length
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

        Stack
            .views(
                on: .vertical,
                distributed: .fillEqually,
                inset: NSDirectionalEdgeInsets(top: 25, leading: 15, bottom: 5, trailing: 15),
                Stack.views(label),
                Stack.views(
                    on: .vertical,
                    distributed: .fillEqually,
                    spacing: 5,
                    Stack.views(
                        distributed: .fillEqually,
                        spacing: 5,
                        ConfiguredButton(text: "1", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        ConfiguredButton(text: "2", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        ConfiguredButton(text: "3", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:)))
                    ),
                    Stack.views(
                        distributed: .fillEqually,
                        spacing: 5,
                        ConfiguredButton(text: "4", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        ConfiguredButton(text: "5", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        ConfiguredButton(text: "6", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:)))
                    ),
                    Stack.views(
                        distributed: .fillEqually,
                        spacing: 5,
                        ConfiguredButton(text: "7", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        ConfiguredButton(text: "8", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        ConfiguredButton(text: "9", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:)))
                    ),
                    Stack.views(
                        distributed: .fillEqually,
                        spacing: 5,
                        SymbolButton(name: "delete.left", tintColor: .white, target: self, action: #selector(didTapDelete)),
                        ConfiguredButton(text: "0", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapButton(sender:))),
                        FlexibleSpace()
                    )
                )
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

    @objc private func didTapButton(sender: UIButton) {
        numbers.append(sender.titleLabel?.text ?? "")
        updateLabel()
    }

    @objc private func didTapDelete() {
        if !numbers.isEmpty {
            numbers.removeLast()
            updateLabel()
        }
    }

    @objc private func didTapStart() {
        guard
            let value = Int(numbers),
            value > 99
        else { return }

        navigation.navigate(to: .idle(in: Session(template: template, pin: value)))
    }
}
