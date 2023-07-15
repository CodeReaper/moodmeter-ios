import UIKit
import SugarKit

protocol NumPadEvents {
    func didTap(button: Int)
    func didTapDelete()
}

class NumPad: UIView {
    private let delegate: NumPadEvents?

    init(delegate: NumPadEvents? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)

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
        ).setup(in: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapButton(sender: UIButton) {
        guard let button = Int(sender.titleLabel?.text ?? "") else { return }
        delegate?.didTap(button: button)
    }

    @objc private func didTapDelete() {
        delegate?.didTapDelete()
    }
}
