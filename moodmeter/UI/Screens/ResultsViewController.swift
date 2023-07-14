import UIKit
import SugarKit

class ResultsViewController: ViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let session: Session
    private let sections: [Section]

    init(navigation: AppNavigation, with session: Session) {
        self.session = session
        sections = session.template.items.map { item in
            Section(title: item.question, rows: (item.minimum...item.maximum).map { value in
                Row.item(value: value, count: session.votes[item.id]?.filter({ $0 == value }).count ?? 0)
            })
        }
        super.init(navigation: navigation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = session.template.name

        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")!,
            style: .plain,
            target: self,
            action: #selector(didTapStop)
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
    }

    struct Section {
        let title: String
        let rows: [Row]
    }

    enum Row {
        case item(value: Int, count: Int)
    }

    private class Cell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    @objc private func didTapStop() {
        navigation.navigate(to: .endSession)
    }
}

extension ResultsViewController: UITableViewDataSource {
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
        case let .item(value, count):
            let cell = tableView.dequeueReusableCell(Cell.self, forIndexPath: indexPath)
            cell.textLabel?.text = "\(value)"
            cell.detailTextLabel?.text = "\(count)"
            return cell
        }
    }
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }

        view.textLabel?.textColor = .white
    }
}
