import UIKit
import SugarKit

class SetupViewController: ViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let storage: Storage<Template>

    init(navigation: AppNavigation, templates: Storage<Template>) {
        self.storage = templates
        super.init(navigation: navigation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Translations.SETUP_TITLE

        tableView
            .set(datasource: self, delegate: self)
            .set(backgroundColor: Color.primary)
            .registerClass(Cell.self)
            .setup(in: view)

        tableView.allowsSelectionDuringEditing = true

        updateBarButtons()
    }

    private func updateBarButtons() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "xmark")!,
                style: .plain,
                target: self,
                action: #selector(toogleEditing)
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "line.3.horizontal")!,
                style: .plain,
                target: self,
                action: #selector(didTapMenu)
            )
        }
    }

    private class Cell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    @objc private func toogleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        updateBarButtons()
    }

    @objc private func didTapMenu() {
        UIAlertController.build(with: [
            .button(text: Translations.MENU_ADD_ITEM, action: { _ in
                self.storage.save(Template(name: "-", items: []))
                self.tableView.insertRows(at: [IndexPath(row: self.storage.count - 1, section: 0)], with: .automatic)
            }),
            .button(text: Translations.MENU_EDIT, action: { _ in
                self.toogleEditing()
            }),
            .button(text: Translations.MENU_LICENSES, action: { _ in
                self.navigation.navigate(to: .licenses)
            }),
            .cancel(text: Translations.GENERIC_CANCEL, action: nil)
        ]).present(in: self, animated: true)
    }
}

extension SetupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let template = storage.item(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(Cell.self, forIndexPath: indexPath)
        cell.textLabel?.text = template.name
        cell.accessoryType = .disclosureIndicator
        cell.editingAccessoryType = .disclosureIndicator
        return cell
    }
}

extension SetupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        navigation.navigate(to: tableView.isEditing ? .editor(with: storage.edit(index: indexPath.row)) : .configure(with: storage.item(at: indexPath.row)))
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        storage.move(index: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            storage.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .none, .insert:
            fallthrough
        @unknown default:
            return
        }
    }
}
