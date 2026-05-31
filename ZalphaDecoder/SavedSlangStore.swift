//
//  SavedSlangStore.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import Foundation

/// Example sentence generated for a saved slang expression.
struct SavedSlangExample: Codable, Identifiable {
    let id: UUID
    let sentence: String
    let meaning: String
    let createdAt: Date
}

/// Locally saved slang or expression collected from Decode Notes.
struct SavedSlang: Codable, Identifiable {
    let id: UUID
    let sourceExpression: String
    let normalizedExpression: String
    let sourceLanguage: String
    var meanings: [String]
    var translatedExpressions: [String]
    var examples: [SavedSlangExample]
    let createdAt: Date
    var updatedAt: Date
    var seenCount: Int

    init(
        id: UUID,
        sourceExpression: String,
        normalizedExpression: String,
        sourceLanguage: String,
        meanings: [String],
        translatedExpressions: [String],
        examples: [SavedSlangExample] = [],
        createdAt: Date,
        updatedAt: Date,
        seenCount: Int
    ) {
        self.id = id
        self.sourceExpression = sourceExpression
        self.normalizedExpression = normalizedExpression
        self.sourceLanguage = sourceLanguage
        self.meanings = meanings
        self.translatedExpressions = translatedExpressions
        self.examples = examples
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.seenCount = seenCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        sourceExpression = try container.decode(String.self, forKey: .sourceExpression)
        normalizedExpression = try container.decode(String.self, forKey: .normalizedExpression)
        sourceLanguage = try container.decodeIfPresent(String.self, forKey: .sourceLanguage)
            ?? SavedSlang.inferredLanguageName(for: sourceExpression)
        meanings = try container.decode([String].self, forKey: .meanings)
        translatedExpressions = try container.decode([String].self, forKey: .translatedExpressions)
        examples = try container.decodeIfPresent([SavedSlangExample].self, forKey: .examples) ?? []
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        seenCount = try container.decode(Int.self, forKey: .seenCount)
    }

    private static func inferredLanguageName(for text: String) -> String {
        text.unicodeScalars.contains { scalar in
            switch scalar.value {
            case 0x1100...0x11FF, 0x3130...0x318F, 0xAC00...0xD7AF, 0xA960...0xA97F, 0xD7B0...0xD7FF:
                return true
            default:
                return false
            }
        } ? "한국어" : "English"
    }
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
    private let maximumExampleCount = 8
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
    func save(_ note: DecodeNote, sourceLanguage: String) -> SavedSlangSaveResult {
        let sourceExpression = note.sourceExpression.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedExpression = normalize(sourceExpression)
        let sourceLanguage = sourceLanguage.trimmingCharacters(in: .whitespacesAndNewlines)

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
                sourceLanguage: sourceLanguage.isEmpty ? "Unknown" : sourceLanguage,
                meanings: meaning.isEmpty ? [] : [meaning],
                translatedExpressions: translatedExpression.isEmpty ? [] : [translatedExpression],
                examples: [],
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

    /// Replaces examples for one saved slang item.
    func replaceExamples(_ examples: [SavedSlangExample], for id: UUID) -> SavedSlang? {
        var items = loadItems()
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        var uniqueExamples: [SavedSlangExample] = []
        examples.forEach {
            _ = appendUniqueExample($0, to: &uniqueExamples)
        }

        guard !uniqueExamples.isEmpty else {
            return items[index]
        }

        var item = items[index]
        item.examples = uniqueExamples
        item.updatedAt = Date()
        items[index] = item
        persist(items)
        return item
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

    /// Removes one generated example from a saved slang item.
    func deleteExample(id exampleID: UUID, from slangID: UUID) -> SavedSlang? {
        var items = loadItems()
        guard let index = items.firstIndex(where: { $0.id == slangID }) else {
            return nil
        }

        var item = items[index]
        item.examples.removeAll { $0.id == exampleID }
        item.updatedAt = Date()
        items[index] = item
        persist(items)
        return item
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

    private func appendUniqueExample(_ example: SavedSlangExample, to examples: inout [SavedSlangExample]) -> Bool {
        let trimmedSentence = example.sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMeaning = example.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedSentence = normalize(trimmedSentence)

        guard !trimmedSentence.isEmpty,
              !trimmedMeaning.isEmpty,
              !normalizedSentence.isEmpty,
              examples.count < maximumExampleCount else {
            return false
        }

        let existingSentences = Set(examples.map { normalize($0.sentence) })
        guard !existingSentences.contains(normalizedSentence) else {
            return false
        }

        examples.append(
            SavedSlangExample(
                id: example.id,
                sentence: trimmedSentence,
                meaning: trimmedMeaning,
                createdAt: example.createdAt
            )
        )
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
