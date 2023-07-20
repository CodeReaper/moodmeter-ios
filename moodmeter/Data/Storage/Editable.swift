import Foundation

protocol Editable: AnyObject {
    var name: String { get set }

    var id: String { get }
    var type: String { get }
    var itemType: String { get }
    var items: [String] { get }

    var canAdd: Bool { get }
    var canEdit: Bool { get }

    func add()
    func move(index: Int, to destination: Int)
    func edit(index: Int) -> Editable
    func delete(index: Int)
    func delete()
    func save()
}

extension Storage where T == Template {
    func edit(index: Int) -> Editable {
        return EditableTemplate(item(at: index), storage: self)
    }
}

private class EditableTemplate {
    private let storage: Storage<Template>
    private var template: Template

    init(_ template: Template, storage: Storage<Template>) {
        self.template = template
        self.storage = storage
    }

    func save(editable: EditableItem) {
        var list = template.items
        list.remove(at: editable.index)
        list.insert(editable.item, at: editable.index)
        template = Template(id: template.id, name: template.name, items: list)
        save()
    }
}

extension EditableTemplate: Editable {
    var id: String { template.id }

    var type: String { Translations.EDITOR_SECTION_NAME }

    var itemType: String { Translations.EDITOR_SECTION_QUESTIONS }

    var name: String {
        get { template.name }
        set { template = Template(id: template.id, name: newValue, items: template.items) }
    }

    var items: [String] { template.items.map { $0.question } }

    var canAdd: Bool { true }

    var canEdit: Bool { true }

    func add() {
        var list = template.items
        list.append(Template.Item(question: "-", answers: []))
        template = Template(id: template.id, name: template.name, items: list)
    }

    func move(index: Int, to destination: Int) {
        let item = template.items[index]
        var list = template.items
        list.remove(at: index)
        list.insert(item, at: destination)
        template = Template(id: template.id, name: template.name, items: list)
    }

    func edit(index: Int) -> Editable {
        return EditableItem(template.items[index], index: index, delegate: self)
    }

    func delete(index: Int) {
        var list = template.items
        list.remove(at: index)
        template = Template(id: template.id, name: template.name, items: list)
    }

    func delete() {
        storage.delete(template)
    }

    func save() {
        storage.save(template)
    }
}

private class EditableItem {
    private let delegate: EditableTemplate
    let index: Int
    var item: Template.Item

    init(_ item: Template.Item, index: Int, delegate: EditableTemplate) {
        self.delegate = delegate
        self.index = index
        self.item = item
    }

    func save(editable: EditableAnswer) {
        var list = item.answers
        list.remove(at: editable.index)
        list.insert(editable.answer, at: editable.index)
        item = Template.Item(id: item.id, question: item.question, answers: list)
        save()
    }
}

extension EditableItem: Editable {
    var id: String { item.id }

    var type: String { Translations.EDITOR_SECTION_QUESTIONS }

    var itemType: String { Translations.EDITOR_SECTION_ANSWERS }

    var name: String {
        get { item.question }
        set { item = Template.Item(id: item.id, question: newValue, answers: item.answers) }
    }

    var items: [String] { item.answers }

    var canAdd: Bool { true }

    var canEdit: Bool { true }

    func add() {
        var list = item.answers
        list.append("-")
        item = Template.Item(id: item.id, question: item.question, answers: list)
    }

    func move(index: Int, to destination: Int) {
        let answer = item.answers[index]
        var list = item.answers
        list.remove(at: index)
        list.insert(answer, at: destination)
        item = Template.Item(id: item.id, question: item.question, answers: list)
    }

    func edit(index: Int) -> Editable {
        return EditableAnswer(item.answers[index], index: index, delegate: self)
    }

    func delete(index: Int) {
        var list = item.answers
        list.remove(at: index)
        item = Template.Item(id: item.id, question: item.question, answers: list)
    }

    func delete() {
        delegate.delete(index: index)
    }

    func save() {
        delegate.save(editable: self)
    }
}

private class EditableAnswer {
    private let delegate: EditableItem

    let index: Int
    var answer: String

    init(_ answer: String, index: Int, delegate: EditableItem) {
        self.delegate = delegate
        self.index = index
        self.answer = answer
    }
}

extension EditableAnswer: Editable {
    var id: String { answer }

    var type: String { Translations.EDITOR_SECTION_ANSWERS }

    var itemType: String { "" }

    var name: String {
        get { answer }
        set { answer = newValue }
    }

    var items: [String] { [] }

    var canAdd: Bool { false }

    var canEdit: Bool { false }

    func add() {}

    func move(index: Int, to destination: Int) {}

    func edit(index: Int) -> Editable { return self }

    func delete(index: Int) {}

    func delete() {
        delegate.delete(index: index)
    }

    func save() {
        delegate.save(editable: self)
    }
}
