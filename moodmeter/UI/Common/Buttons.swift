import UIKit
import SugarKit

class ConfiguredButton: Button {
    private let roundedCorners: Bool

    init(text: String, textColor: UIColor = .white, borderColor: UIColor? = nil, backgroundColor: UIColor? = nil, roundedCorners: Bool = false, target: Any? = nil, action: Selector? = nil) {
        self.roundedCorners = roundedCorners
        super.init(text: text, textColor: textColor, target: target, action: action)
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let borderColor = borderColor {
            layer.borderWidth = 1
            layer.borderColor = borderColor.cgColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if roundedCorners {
            layer.cornerRadius = min(bounds.height, bounds.width) / 3.0
        }
    }
}

class ImageButton: UIButton {
    init(image: UIImage, target: Any? = nil, action: Selector? = nil) {
        super.init(frame: .zero)
        for state in [UIControl.State.normal, .highlighted, .selected] {
            setImage(image, for: state)
        }
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SymbolButton: ImageButton {
    init(name: String, tintColor: UIColor?, target: Any? = nil, action: Selector? = nil) {
        super.init(image: UIImage(systemName: name)!, target: target, action: action)

        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
