//
//  AIService.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import FirebaseAILogic
import Foundation

enum AIServiceError: Error {
    case emptyResponse
}

final class AIService {
    private lazy var model = FirebaseAI.firebaseAI(backend: .googleAI()).generativeModel(modelName: "gemini-2.5-flash")

    func generateGreeting() async throws -> String {
        let prompt = "Say hello in one short friendly English sentence. Return only the sentence."
        let response = try await model.generateContent(prompt)
        let text = response.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !text.isEmpty else {
            throw AIServiceError.emptyResponse
        }

        return text
    }
}
