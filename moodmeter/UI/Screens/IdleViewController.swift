import UIKit
import SugarKit

class IdleViewController: ViewController {
    private let session: Session

    init(navigation: AppNavigation, with session: Session) {
        self.session = session
        super.init(navigation: navigation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Ready"

        Stack
            .views(
                on: .vertical,
                distributed: .fill,
                spacing: 40,
                inset: NSDirectionalEdgeInsets(top: 25, leading: 15, bottom: 5, trailing: 15),
                FlexibleSpace(),
                Label(text: "\(session.votes.values.first?.count ?? 0) votes registered").aligned(to: .center),
                FlexibleSpace(),
                ConfiguredButton(text: "Vote", borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapVote)).set(height: 60),
                ConfiguredButton(text: "End session", borderColor: .white, backgroundColor: Color.secondary, roundedCorners: true, target: self, action: #selector(didTapEnd)).set(height: 60)
            )
            .apply(flexible: .fillEqual)
            .layout(in: view) { make, its in
                make(its.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
                make(its.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
                make(its.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
                make(its.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
            }
    }

    @objc private func didTapVote() {
        navigation.navigate(to: .vote(in: session))
    }

    @objc private func didTapEnd() {
        guard let navigationController = self.navigationController else { return }

        UIAlertController.build(with: [
            .title(text: "Locked"),
            .message(text: "Enter pin"),
            .style(preference: .alert),
            .textField({ field in
                field.placeholder = "Enter pin"
                field.keyboardType = .numberPad
            }),
            .button(text: "OK", action: { [weak self] alert in
                guard
                    let session = self?.session,
                    let text = alert.textFields?.first?.text,
                    let pin = Int(text),
                    pin == session.pin
                else {
                    UIAlertController.build(with: [
                        .title(text: "Failed"),
                        .message(text: "Incorrect pin"),
                        .style(preference: .alert),
                        .button(text: "OK", action: { _ in })
                    ]).present(in: navigationController, animated: true)
                    return
                }
                self?.navigation.navigate(to: .results(in: session))
            }),
            .danger(text: "Abort", action: { [weak self] alert in
                UIAlertController.build(with: [
                    .title(text: "Are you sure?"),
                    .message(text: "All entered data will be lost!"),
                    .style(preference: .alert),
                    .button(text: "OK", action: { [weak self] _ in
                        self?.navigation.navigate(to: .endSession)
                    }),
                    .cancel(text: "Cancel", action: nil)
                ]).present(in: navigationController, animated: true)
            }),
            .cancel(text: "Cancel", action: nil)
        ]).present(in: navigationController, animated: true)
    }
}
