//
//  AIServiceModels.swift
//  ZalphaDecoder
//

import Foundation

/// Normalized AI errors that the UI can map to user-facing messages.
enum AIServiceError: Error {
    case emptyResponse
    case blocked
    case rateLimited
    case networkUnavailable
    case serviceUnavailable
    case configuration
    case invalidResponse
}

/// Structured Decode Note that can later become a vocabulary item.
struct DecodeNote: Codable {
    let sourceExpression: String
    let meaning: String
    let meaningLanguage: String
    let translatedExpression: String

    init(
        sourceExpression: String,
        meaning: String,
        meaningLanguage: String = "English",
        translatedExpression: String
    ) {
        self.sourceExpression = sourceExpression
        self.meaning = meaning
        self.meaningLanguage = meaningLanguage
        self.translatedExpression = translatedExpression
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceExpression = try container.decode(String.self, forKey: .sourceExpression)
        meaning = try container.decode(String.self, forKey: .meaning)
        meaningLanguage = try container.decodeIfPresent(String.self, forKey: .meaningLanguage) ?? "English"
        translatedExpression = try container.decode(String.self, forKey: .translatedExpression)
    }
}

/// Parsed Gemini response containing the final decoded output and optional notes.
struct DecodeResult: Decodable {
    let result: String
    let notes: [DecodeNote]
}

/// Generated example sentence for a saved slang expression.
struct GeneratedSlangExample: Decodable {
    let sentence: String
    let meaning: String
}
