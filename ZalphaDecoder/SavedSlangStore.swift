//
//  SavedSlangStore.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import Foundation

/// Locally saved slang or expression collected from Decode Notes.
struct SavedSlang: Codable, Identifiable {
    let id: UUID
    let sourceExpression: String
    let normalizedExpression: String
    var meanings: [String]
    var translatedExpressions: [String]
    let createdAt: Date
    var updatedAt: Date
    var seenCount: Int
}

/// Result of saving a Decode Note into the saved slang list.
enum SavedSlangSaveResult {
    case saved
    case updated
    case duplicate
    case invalid

    var message: String {
        switch self {
        case .saved:
            return "Saved."
        case .updated:
            return "Already saved. Updated."
        case .duplicate:
            return "Already saved."
        case .invalid:
            return "Could not save this note."
        }
    }
}

/// Small UserDefaults-backed store for saved slang notes.
final class SavedSlangStore {
    static let shared = SavedSlangStore()

    private let storageKey = "zalpha.saved.slangs.items"
    private let maximumVariantCount = 8
    private let userDefaults: UserDefaults

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    /// Loads saved slang items sorted by most recently updated first.
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

    /// Saves one Decode Note, deduplicating by normalized source expression.
    @discardableResult
    func save(_ note: DecodeNote) -> SavedSlangSaveResult {
        let sourceExpression = note.sourceExpression.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedExpression = normalize(sourceExpression)

        guard !sourceExpression.isEmpty, !normalizedExpression.isEmpty else {
            return .invalid
        }

        let meaning = note.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        let translatedExpression = note.translatedExpression.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = Date()
        var items = loadItems()

        guard let existingIndex = items.firstIndex(where: { $0.normalizedExpression == normalizedExpression }) else {
            let item = SavedSlang(
                id: UUID(),
                sourceExpression: sourceExpression,
                normalizedExpression: normalizedExpression,
                meanings: meaning.isEmpty ? [] : [meaning],
                translatedExpressions: translatedExpression.isEmpty ? [] : [translatedExpression],
                createdAt: now,
                updatedAt: now,
                seenCount: 1
            )
            items.insert(item, at: 0)
            persist(items)
            return .saved
        }

        var item = items[existingIndex]
        let didAddMeaning = appendUnique(meaning, to: &item.meanings)
        let didAddTranslatedExpression = appendUnique(translatedExpression, to: &item.translatedExpressions)
        item.updatedAt = now
        item.seenCount += 1
        items[existingIndex] = item
        persist(items)

        return didAddMeaning || didAddTranslatedExpression ? .updated : .duplicate
    }

    /// Removes all locally saved slang items.
    func clear() {
        userDefaults.removeObject(forKey: storageKey)
    }

    /// Removes one locally saved slang item by id.
    func delete(id: UUID) {
        let items = loadItems().filter { $0.id != id }
        persist(items)
    }

    private func appendUnique(_ value: String, to values: inout [String]) -> Bool {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedValue = normalize(trimmedValue)

        guard !trimmedValue.isEmpty, !normalizedValue.isEmpty else {
            return false
        }

        let existingValues = Set(values.map(normalize))
        guard !existingValues.contains(normalizedValue), values.count < maximumVariantCount else {
            return false
        }

        values.append(trimmedValue)
        return true
    }

    private func normalize(_ value: String) -> String {
        let quoteCharacters = CharacterSet(charactersIn: "\"'“”‘’")
        let edgeCharacters = CharacterSet.whitespacesAndNewlines
            .union(.punctuationCharacters)
            .union(quoteCharacters)

        let withoutQuotes = value
            .components(separatedBy: quoteCharacters)
            .joined()
        let collapsedWhitespace = withoutQuotes
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return collapsedWhitespace
            .trimmingCharacters(in: edgeCharacters)
            .lowercased()
    }

    private func persist(_ items: [SavedSlang]) {
        do {
            let data = try JSONEncoder().encode(items.sorted { $0.updatedAt > $1.updatedAt })
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Failed to save slangs:", error)
        }
    }
}
