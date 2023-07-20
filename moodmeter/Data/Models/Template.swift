import Foundation

struct Template: Codable, Storable {
    let id: String
    let name: String
    let items: [Item]

    struct Item: Codable {
        let id: String
        let question: String
        let answers: [String]
    }
}

extension Template {
    init(name: String, items: [Item]) {
        id = UUID().uuidString
        self.name = name
        self.items = items
    }
}

extension Template.Item {
    init(question: String, answers: [String]) {
        id = UUID().uuidString
        self.question = question
        self.answers = answers
    }
}
