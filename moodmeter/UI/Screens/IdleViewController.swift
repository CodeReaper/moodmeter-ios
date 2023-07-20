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

        title = Translations.IDLE_TITLE

        Stack.views(
            on: .vertical,
            distributed: .fill,
            spacing: 40,
            inset: NSDirectionalEdgeInsets(top: 25, leading: 15, bottom: 5, trailing: 15),
            FlexibleSpace(),
            Label(text: Translations.IDLE_VOTES_REGISTERED("\(session.votes.values.first?.count ?? 0)")).aligned(to: .center),
            FlexibleSpace(),
            ConfiguredButton(text: Translations.IDLE_BUTTON_VOTE, borderColor: .white, roundedCorners: true, target: self, action: #selector(didTapVote)).set(height: 60),
            ConfiguredButton(text: Translations.IDLE_BUTTON_END, borderColor: .white, backgroundColor: Color.secondary, roundedCorners: true, target: self, action: #selector(didTapEnd)).set(height: 60)
        )
        .apply(flexible: .fillEqual)
        .setup(in: view)
    }

    @objc private func didTapVote() {
        navigation.navigate(to: .vote(in: session))
    }

    @objc private func didTapEnd() {
        guard let navigationController = self.navigationController else { return }

        UIAlertController.build(with: [
            .title(text: Translations.ALERT_END_SESSION_TITLE),
            .message(text: Translations.ALERT_END_SESSION_MESSAGE),
            .style(preference: .alert),
            .textField({ field in
                field.placeholder = Translations.ALERT_END_SESSION_INPUT_PLACEHOLER
                field.keyboardType = .numberPad
            }),
            .button(text: Translations.GENERIC_OK, action: { [weak self] alert in
                guard
                    let session = self?.session,
                    let text = alert.textFields?.first?.text,
                    let pin = Int(text),
                    pin == session.pin
                else {
                    UIAlertController.build(with: [
                        .title(text: Translations.ALERT_INCORRECT_PIN_TITLE),
                        .message(text: Translations.ALERT_INCORRECT_PIN_MESSAGE),
                        .style(preference: .alert),
                        .button(text: Translations.GENERIC_OK, action: { _ in })
                    ]).present(in: navigationController, animated: true)
                    return
                }
                self?.navigation.navigate(to: .results(in: session))
            }),
            .danger(text: Translations.GENERIC_ABORT, action: { [weak self] _ in
                UIAlertController.build(with: [
                    .title(text: Translations.ALERT_ABORT_SESSION_TITLE),
                    .message(text: Translations.ALERT_ABORT_SESSION_MESSAGE),
                    .style(preference: .alert),
                    .button(text: Translations.GENERIC_OK, action: { [weak self] _ in
                        self?.navigation.navigate(to: .endSession)
                    }),
                    .cancel(text: Translations.GENERIC_CANCEL, action: nil)
                ]).present(in: navigationController, animated: true)
            }),
            .cancel(text: Translations.GENERIC_CANCEL, action: nil)
        ]).present(in: navigationController, animated: true)
    }
}
