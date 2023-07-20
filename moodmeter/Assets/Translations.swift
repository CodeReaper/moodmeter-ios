// swiftlint:disable all
import Foundation
struct Translations {
	static let ALERT_ABORT_SESSION_MESSAGE = NSLocalizedString("ALERT_ABORT_SESSION_MESSAGE", comment: "")
	static let ALERT_ABORT_SESSION_TITLE = NSLocalizedString("ALERT_ABORT_SESSION_TITLE", comment: "")
	static let ALERT_END_SESSION_INPUT_PLACEHOLER = NSLocalizedString("ALERT_END_SESSION_INPUT_PLACEHOLER", comment: "")
	static let ALERT_END_SESSION_MESSAGE = NSLocalizedString("ALERT_END_SESSION_MESSAGE", comment: "")
	static let ALERT_END_SESSION_TITLE = NSLocalizedString("ALERT_END_SESSION_TITLE", comment: "")
	static let ALERT_INCORRECT_PIN_MESSAGE = NSLocalizedString("ALERT_INCORRECT_PIN_MESSAGE", comment: "")
	static let ALERT_INCORRECT_PIN_TITLE = NSLocalizedString("ALERT_INCORRECT_PIN_TITLE", comment: "")
	static let CONFIGURE_TITLE = NSLocalizedString("CONFIGURE_TITLE", comment: "")
	static let GENERIC_ABORT = NSLocalizedString("GENERIC_ABORT", comment: "")
	static let GENERIC_CANCEL = NSLocalizedString("GENERIC_CANCEL", comment: "")
	static let GENERIC_OK = NSLocalizedString("GENERIC_OK", comment: "")
	static let GENERIC_SAVE = NSLocalizedString("GENERIC_SAVE", comment: "")
	static let IDLE_BUTTON_END = NSLocalizedString("IDLE_BUTTON_END", comment: "")
	static let IDLE_BUTTON_VOTE = NSLocalizedString("IDLE_BUTTON_VOTE", comment: "")
	static let IDLE_TITLE = NSLocalizedString("IDLE_TITLE", comment: "")
	static func IDLE_VOTES_REGISTERED(_ p1: String) -> String { return NSLocalizedString("IDLE_VOTES_REGISTERED", comment: "").replacingOccurrences(of: "%1", with: p1) }
	static let LICENSES_ASSETS_TITLE = NSLocalizedString("LICENSES_ASSETS_TITLE", comment: "")
	static let LICENSES_PACKAGES_TITLE = NSLocalizedString("LICENSES_PACKAGES_TITLE", comment: "")
	static let LICENSES_TITLE = NSLocalizedString("LICENSES_TITLE", comment: "")
	static let MENU_ADD_ITEM = NSLocalizedString("MENU_ADD_ITEM", comment: "")
	static let MENU_EDIT = NSLocalizedString("MENU_EDIT", comment: "")
	static let MENU_LICENSES = NSLocalizedString("MENU_LICENSES", comment: "")
	static let MENU_TITLE = NSLocalizedString("MENU_TITLE", comment: "")
	static let SETUP_TITLE = NSLocalizedString("SETUP_TITLE", comment: "")
}
