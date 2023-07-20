import UIKit
import SugarKit

class EditorViewController: ViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let nameField = UITextField()

    private let delegate: Editable

    init(navigation: AppNavigation, with editable: Editable) {
        nameField.text = editable.name
        self.delegate = editable
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

        title = Translations.EDITOR_TITLE

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")!,
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "checkmark")!,
                style: .plain,
                target: self,
                action: #selector(didTapSave)
            )
        ]
        if delegate.canAdd {
            navigationItem.rightBarButtonItems?.append(UIBarButtonItem(
                image: UIImage(systemName: "plus")!,
                style: .plain,
                target: self,
                action: #selector(didTapAdd)
            ))
        }

        tableView
            .set(datasource: self, delegate: self)
            .set(backgroundColor: Color.primary)
            .registerClass(NameCell.self)
            .registerClass(ItemCell.self)
            .layout(in: view) { make, its in
                make(its.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
                make(its.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
                make(its.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
                make(its.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
            }

        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
    }

    private class NameCell: UITableViewCell { }

    private class ItemCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    @objc private func didTapAdd() {
        delegate.add()
        tableView.insertRows(at: [IndexPath(row: delegate.items.count - 1, section: 1)], with: .automatic)
    }

    @objc private func didTapSave() {
        guard let name = nameField.text else { return }
        delegate.name = name
        delegate.save()
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapCancel() {
        UIAlertController.build(with: [
            .title(text: Translations.ALERT_DISMISS_CHANGES_TITLE),
            .message(text: Translations.ALERT_DISMISS_CHANGES_MESSAGE),
            .danger(text: Translations.GENERIC_OK, action: { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }),
            .cancel(text: Translations.GENERIC_CANCEL, action: nil)
        ]).present(in: self, animated: true)
    }
}

extension EditorViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return delegate.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(NameCell.self, forIndexPath: indexPath)
            nameField.setup(matching: cell.contentView, in: cell.contentView, inset: NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            nameField.delegate = self
            nameField.returnKeyType = .done
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(ItemCell.self, forIndexPath: indexPath)
            cell.textLabel?.text = delegate.items[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = .disclosureIndicator
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return delegate.type
        }
        return delegate.itemType
    }
}

extension EditorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section != 0 && delegate.canEdit {
            navigation.navigate(to: .editor(with: delegate.edit(index: indexPath.row)))
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath.section == proposedDestinationIndexPath.section ? proposedDestinationIndexPath : sourceIndexPath
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate.move(index: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .none : .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            delegate.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .none, .insert:
            fallthrough
        @unknown default:
            return
        }
    }
}

extension EditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
