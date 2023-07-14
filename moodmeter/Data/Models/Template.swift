import Foundation

struct Template {
    let name: String
    let items: [Item]

    struct Item {
        let id = UUID().uuidString
        let question: String
        let minimum: Int
        let maximum: Int
    }
}
