//
//  AIServiceResponseParser.swift
//  ZalphaDecoder
//

import Foundation

struct AIServiceResponseParser {
    func parseDecodeResult(from rawText: String, targetLanguage: String) throws -> DecodeResult {
        guard let jsonText = extractJSONObject(from: rawText),
              let data = jsonText.data(using: .utf8) else {
            print("Firebase AI Logic invalid JSON response:", rawText)
            throw AIServiceError.invalidResponse
        }

        do {
            let decodedResult = try JSONDecoder().decode(RawDecodeResult.self, from: data)
            let trimmedResult = decodedResult.result.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmedResult.isEmpty else {
                throw AIServiceError.emptyResponse
            }

            return DecodeResult(
                result: trimmedResult,
                notes: decodedResult.notes
                    .map { note in
                        let meaningLanguage = (note.meaningLanguage ?? "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        return DecodeNote(
                            sourceExpression: note.sourceExpression.trimmingCharacters(in: .whitespacesAndNewlines),
                            meaning: note.meaning.trimmingCharacters(in: .whitespacesAndNewlines),
                            meaningLanguage: meaningLanguage.isEmpty ? targetLanguage : meaningLanguage,
                            translatedExpression: note.translatedExpression.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    }
                    .filter { !$0.sourceExpression.isEmpty && !$0.meaning.isEmpty }
                    .prefix(5)
                    .map { $0 }
            )
        } catch let error as AIServiceError {
            throw error
        } catch {
            print("Firebase AI Logic invalid JSON response:", rawText)
            throw AIServiceError.invalidResponse
        }
    }

    func parseGeneratedExample(from rawText: String) throws -> GeneratedSlangExample {
        guard let jsonText = extractJSONObject(from: rawText),
              let data = jsonText.data(using: .utf8) else {
            print("Firebase AI Logic invalid examples JSON response:", rawText)
            throw AIServiceError.invalidResponse
        }

        do {
            let response = try JSONDecoder().decode(GeneratedExampleResponse.self, from: data)
            let example = GeneratedSlangExample(
                sentence: response.example.sentence.trimmingCharacters(in: .whitespacesAndNewlines),
                meaning: response.example.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
            )

            guard !example.sentence.isEmpty, !example.meaning.isEmpty else {
                throw AIServiceError.emptyResponse
            }

            return example
        } catch let error as AIServiceError {
            throw error
        } catch {
            print("Firebase AI Logic invalid examples JSON response:", rawText)
            throw AIServiceError.invalidResponse
        }
    }

    private func extractJSONObject(from text: String) -> String? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let startIndex = trimmedText.firstIndex(of: "{") else {
            return nil
        }

        var depth = 0
        var isInString = false
        var isEscaped = false
        var index = startIndex

        while index < trimmedText.endIndex {
            let character = trimmedText[index]

            if isEscaped {
                isEscaped = false
            } else if character == "\\" {
                isEscaped = isInString
            } else if character == "\"" {
                isInString.toggle()
            } else if !isInString {
                if character == "{" {
                    depth += 1
                } else if character == "}" {
                    depth -= 1
                    if depth == 0 {
                        return String(trimmedText[startIndex...index])
                    }
                }
            }

            index = trimmedText.index(after: index)
        }

        return nil
    }
}

private struct GeneratedExampleResponse: Decodable {
    let example: GeneratedSlangExample
}

private struct RawDecodeResult: Decodable {
    let result: String
    let notes: [RawDecodeNote]
}

private struct RawDecodeNote: Decodable {
    let sourceExpression: String
    let meaning: String
    let meaningLanguage: String?
    let translatedExpression: String
}
