import UIKit
import SugarKit

class EditorViewController: ViewController {
    private var template: Template

    init(navigation: AppNavigation, with template: Template) {
        self.template = template
        super.init(navigation: navigation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Translations.EDITOR_TITLE"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.down.fill")!,
            style: .plain,
            target: self,
            action: #selector(didTapSave)
        )

        Stack.views(
            on: .vertical,
            distributed: .fillEqually,
            inset: NSDirectionalEdgeInsets(top: 25, leading: 15, bottom: 5, trailing: 15),
            Stack.views(Label(style: .body, text: template.name, color: .black))
        )
        .layout(in: view) { make, its in
            make(its.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            make(its.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
            make(its.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
            make(its.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        }
    }

    @objc private func didTapSave() {
        navigationController?.popViewController(animated: true)
    }
}
