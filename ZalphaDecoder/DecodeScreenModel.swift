//
//  DecodeScreenModel.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import Foundation

/// Main decode screen state and state-only mutations.
final class DecodeScreenModel {
    var isDecoding = false
    var hasShownStartupSplash = false
    var emptyDecodeTapCount = 0
    var selectedStyle: TranslationStyle = .formal
    var sourceLanguage: DecodeLanguage = .auto
    var targetLanguage: DecodeLanguage = .english
    var latestHistoryItem: HistoryItem?

    func selectStyle(_ style: TranslationStyle) {
        selectedStyle = style
    }

    func setLanguage(_ language: DecodeLanguage, changesSource: Bool) {
        if changesSource {
            sourceLanguage = language
        } else {
            targetLanguage = language
        }
    }

    func swapLanguages() {
        if sourceLanguage == .auto {
            sourceLanguage = targetLanguage
            targetLanguage = sourceLanguage.oppositeConcreteLanguage
        } else {
            swap(&sourceLanguage, &targetLanguage)
        }
    }

    func resetEmptyDecodeTapCount() {
        emptyDecodeTapCount = 0
    }

    func nextEmptyDecodeMessage() -> String {
        emptyDecodeTapCount += 1

        guard emptyDecodeTapCount > 3 else {
            return DecodeMessage.emptyInputDefault
        }

        let index = (emptyDecodeTapCount - 4) % DecodeMessage.emptyInputVariants.count
        return DecodeMessage.emptyInputVariants[index]
    }

    func setDecoding(_ isDecoding: Bool) {
        self.isDecoding = isDecoding
    }

    func markStartupSplashShownIfNeeded() -> Bool {
        guard !hasShownStartupSplash else { return false }
        hasShownStartupSplash = true
        return true
    }

    func resolvedSourceLanguage(for input: String) -> DecodeLanguage? {
        InputLanguageDetector.resolvedSourceLanguage(for: input, sourceLanguage: sourceLanguage)
    }

    func sourceLanguageMismatchMessage(for input: String) -> String? {
        InputLanguageDetector.sourceLanguageMismatchMessage(for: input, sourceLanguage: sourceLanguage)
    }

    func recordHistoryItem(
        resolvedSourceLanguage: DecodeLanguage,
        inputText: String,
        decodeResult: DecodeResult,
        id: UUID = UUID(),
        createdAt: Date = Date()
    ) -> HistoryItem {
        let historyItem = HistoryItem(
            id: id,
            createdAt: createdAt,
            sourceLanguage: resolvedSourceLanguage.displayName,
            targetLanguage: targetLanguage.displayName,
            style: selectedStyle.displayName,
            inputText: inputText,
            outputText: decodeResult.result,
            notes: decodeResult.notes
        )
        latestHistoryItem = historyItem
        return historyItem
    }
}

enum DecodeMessage {
    static let emptyInputDefault = "Enter text to decode."
    static let safetyBlocked = "This text could not be decoded safely."
    static let rateLimited = "Too many requests. Try again soon."
    static let networkUnavailable = "Check your connection and try again."
    static let aiUnavailable = "AI is temporarily unavailable."
    static let genericError = "Could not decode. Try again."

    static let emptyInputVariants = [
        "Bro, it's empty.",
        "There is nothing to decode.",
        "Bro, this ain't tuff. 🥀",
        "No text? We are cooked.",
        "Is bro okay?",
        "Type something plz 🙏",
        "No words, no decode.",
        "Skibidi Toilet",
        "I mog you btw...",
        "Messi or Ronaldo ???",
        "Zalpha needs actual text, bro.",
        "Idc at this moment",
        "This is sub3 behavior",
        "Never expected someone doing this",
        "you win bro",
        "go sleep plz",
        "Enter text to decode.",
        "Enter text to decode.",
        "Enter text to decode.",
        "touch grass plz"
    ]
}
