import UIKit
import SugarKit

class VoteViewController: ViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let session: Session

    private var selected: [IndexPath] = []
    private var sections: [Section]!

    init(navigation: AppNavigation, with session: Session) {
        self.session = session
        super.init(navigation: navigation)

        sections = session.template.items.map {
            Section(title: $0.question, rows: $0.answers.map {
                Row.item(value: $0)
            })
        } + [Section(title: "", rows: [.finish])]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = session.template.name

        tableView
            .set(datasource: self, delegate: self)
            .set(backgroundColor: Color.primary)
            .registerClass(Cell.self)
            .setup(in: view)
    }

    struct Section {
        let title: String
        let rows: [Row]
    }

    enum Row {
        case item(value: String)
        case finish
    }

    private class Cell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    @objc private func didTapSave() {
        navigation.navigate(to: .idle(in: session))
    }
}

extension VoteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case let .item(value):
            let cell = tableView.dequeueReusableCell(Cell.self, forIndexPath: indexPath)
            cell.textLabel?.text = value
            cell.accessoryType = selected.contains(indexPath) ? .checkmark : .none
            cell.tintColor = Color.primary
            return cell
        case .finish:
            let cell = tableView.dequeueReusableCell(Cell.self, forIndexPath: indexPath)
            cell.textLabel?.text = Translations.GENERIC_SAVE
            cell.accessoryType = .none
            return cell
        }
    }
}

extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected.removeAll(where: { $0.section == indexPath.section })
        if indexPath.section < session.template.items.count {
            selected.append(indexPath)
            tableView.reloadData()
        } else if session.template.items.count == selected.count {
            for item in selected {
                let id = session.template.items[item.section].id
                let value = item.row

                var values = session.votes[id] ?? []
                values.append(value)
                session.votes[id] = values
            }
            navigation.navigate(to: .idle(in: session))
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }

        view.textLabel?.textColor = .white
    }
}
