import UIKit
import SugarKit

class SetupViewController: ViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var rows: [Row]!

    override init(navigation: AppNavigation) {
        super.init(navigation: navigation)

        // TODO: manage templates instead of this hardcoded one
        let template = Template(
            name: "Fridays voting session",
            items: [
                Template.Item(question: "How stressed are you?", answers: ["1", "2", "3", "4", "5"]),
                Template.Item(question: "How are you?", answers: ["1", "2", "3", "4", "5"])
            ]
        )

        rows = [
            Row.item(template: template),
            Row.item(template: template)
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Translations.SETUP_TITLE

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "questionmark.circle.fill")!,
            style: .plain,
            target: self,
            action: #selector(didTapQuestionMark)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "text.badge.plus")!,
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )

        tableView
            .set(datasource: self, delegate: self)
            .set(backgroundColor: Color.primary)
            .registerClass(Cell.self)
            .layout(in: view) { make, its in
                make(its.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
                make(its.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
                make(its.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
                make(its.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
            }

        tableView.allowsSelectionDuringEditing = true
    }

    enum Row {
        case item(template: Template)
    }

    private class Cell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    @objc private func didTapQuestionMark() {
        navigation.navigate(to: .licenses)
    }

    @objc private func didTapEdit() {
        navigationItem.leftBarButtonItem?.isEnabled = tableView.isEditing
        tableView.setEditing(!tableView.isEditing, animated: true)
        tableView.reloadData()
    }
}

extension SetupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.isEditing ? rows.count + 1 : rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(Cell.self, forIndexPath: indexPath)
        guard indexPath.row < rows.count else {
            cell.textLabel?.text = nil
            cell.accessoryType = .none
            return cell
        }

        switch rows[indexPath.row] {
        case let .item(template):
            cell.textLabel?.text = template.name
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = .disclosureIndicator
            return cell
        }
    }
}

extension SetupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch rows[indexPath.row] {
        case let .item(template):
            navigation.navigate(to: tableView.isEditing ? .editor(with: template) : .configure(with: template))
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard indexPath.row < rows.count else {
            return .insert
        }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            rows.append(Row.item(template: Template(name: "New item", items: [])))
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .none:
            fallthrough
        @unknown default:
            return
        }
    }
}
