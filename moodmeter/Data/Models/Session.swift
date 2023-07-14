import Foundation

class Session {
    let template: Template
    let pin: Int

    var votes: [String: [Int]] = [:]

    init(template: Template, pin: Int) {
        self.template = template
        self.pin = pin
    }
}
