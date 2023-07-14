import Foundation

struct Template: Codable {
    let name: String
    let items: [Item]

    struct Item: Codable {
        let id: String
        let question: String
        let answers: [String]
    }
}

extension Template.Item {
    init(question: String, answers: [String]) {
        id = UUID().uuidString
        self.question = question
        self.answers = answers
    }
}
