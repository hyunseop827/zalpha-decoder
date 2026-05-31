//
//  SavedSlangPersistence.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import Foundation

struct SavedSlangPersistence {
    private let storageKey = "zalpha.saved.slangs.items"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadItems() -> [SavedSlang] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return []
        }

        do {
            let items = try JSONDecoder().decode([SavedSlang].self, from: data)
            return items.sorted { $0.updatedAt > $1.updatedAt }
        } catch {
            print("Failed to load saved slangs:", error)
            return []
        }
    }

    func save(_ items: [SavedSlang]) {
        do {
            let data = try JSONEncoder().encode(items.sorted { $0.updatedAt > $1.updatedAt })
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Failed to save slangs:", error)
        }
    }

    func clear() {
        userDefaults.removeObject(forKey: storageKey)
    }
}
