import Foundation

class Storage<T: Codable & Storable> {
    private let tag: String
    private let url = URL.applicationSupportDirectory
    private var store: Store

    init(tag: String) {
        if !FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        self.tag = tag
        self.store = Storage<T>.retrieveStore(at: url, with: tag)
    }

    var count: Int { store.items.count }

    func item(at index: Int) -> T {
        return retrieve(id: store.items[index])
    }

    func save(_ item: T) {
        persist(item)
        if !store.items.contains(item.id) {
            store.items.append(item.id)
        }
        persistStore()
    }

    func move(index: Int, to destination: Int) {
        let id = store.items[index]
        store.items.remove(at: index)
        store.items.insert(id, at: destination)
        persistStore()
    }

    func delete(index: Int) {
        delete(item(at: index))
    }

    // swiftlint:disable force_try

    func delete(_ item: T) {
        store.items.removeAll(where: { $0 == item.id })
        persistStore()
        try! FileManager.default.removeItem(at: url.appending(path: "\(item.id).\(tag)"))
    }

    private func retrieve(id: String) -> T {
        return try! JSONDecoder().decode(T.self, from: Data(contentsOf: url.appending(path: "\(id).\(tag)")))
    }

    private class func retrieveStore(at url: URL, with tag: String) -> Store {
        let storeUrl = url.appending(path: "\(tag).store")

        if FileManager.default.fileExists(atPath: storeUrl.path(percentEncoded: false)) {
            return try! JSONDecoder().decode(Store.self, from: Data(contentsOf: storeUrl))
        } else {
            return Store(version: 0, items: [])
        }
    }

    private func persist(_ item: T) {
        try! JSONEncoder().encode(item).write(to: url.appending(path: "\(item.id).\(tag)"))
    }

    private func persistStore() {
        try! JSONEncoder().encode(store).write(to: url.appending(path: "\(tag).store"))
    }

    // swiftlint:enable force_try
}

private struct Store: Codable {
    var version: Int
    var items: [String]
}
