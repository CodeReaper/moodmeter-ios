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
            Row.item(label: template.name, onSelection: { [weak self] in
                self?.navigation.navigate(to: .configure(with: template))
            })
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Templates"

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
    }

    enum Row {
        case item(label: String, onSelection: (() -> Void)?)
    }

    private class Cell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension SetupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .item(label, endpoint):
            let cell = tableView.dequeueReusableCell(Cell.self, forIndexPath: indexPath)
            cell.textLabel?.text = label
            cell.accessoryType = endpoint == nil ? .none : .disclosureIndicator
            return cell
        }
    }
}

extension SetupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch rows[indexPath.row] {
        case let .item(_, onSelection):
            onSelection?()
        }
    }
}
