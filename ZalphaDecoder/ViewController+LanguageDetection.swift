//
//  ViewController+LanguageDetection.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import NaturalLanguage
import UIKit

extension ViewController {

    func resolvedSourceLanguage(for input: String) -> Language? {
        guard sourceLanguage == .auto else {
            return sourceLanguage
        }

        return detectInputLanguage(input)
    }

    func sourceLanguageMismatchMessage(for input: String) -> String? {
        guard sourceLanguage != .auto, shouldCheckExplicitSource(for: input) else {
            return nil
        }
        guard let detectedLanguage = detectInputLanguage(input), detectedLanguage != sourceLanguage else {
            return nil
        }

        return "Input looks \(detectedLanguage.displayName). Check source language."
    }

    private func shouldCheckExplicitSource(for input: String) -> Bool {
        let counts = scriptCounts(in: input)
        return counts.hangul + counts.latin >= 4
    }

    private func detectInputLanguage(_ input: String) -> Language? {
        let counts = scriptCounts(in: input)

        if counts.hangul > 0, counts.latin == 0 {
            return .korean
        }
        if counts.latin > 0, counts.hangul == 0 {
            return .english
        }
        if counts.hangul >= 2, counts.hangul >= counts.latin * 2 {
            return .korean
        }
        if counts.latin >= 2, counts.latin >= counts.hangul * 2 {
            return .english
        }

        let recognizer = NLLanguageRecognizer()
        recognizer.processString(input)
        let hypotheses = recognizer.languageHypotheses(withMaximum: 2)

        if (hypotheses[.korean] ?? 0) >= 0.7 {
            return .korean
        }
        if (hypotheses[.english] ?? 0) >= 0.7 {
            return .english
        }

        return nil
    }

    private func scriptCounts(in input: String) -> (hangul: Int, latin: Int) {
        input.unicodeScalars.reduce(into: (hangul: 0, latin: 0)) { counts, scalar in
            if isHangul(scalar) {
                counts.hangul += 1
            } else if isLatinLetter(scalar) {
                counts.latin += 1
            }
        }
    }

    private func isHangul(_ scalar: UnicodeScalar) -> Bool {
        switch scalar.value {
        case 0x1100...0x11FF, 0x3130...0x318F, 0xAC00...0xD7AF, 0xA960...0xA97F, 0xD7B0...0xD7FF:
            return true
        default:
            return false
        }
    }

    private func isLatinLetter(_ scalar: UnicodeScalar) -> Bool {
        (0x0041...0x005A).contains(scalar.value) || (0x0061...0x007A).contains(scalar.value)
    }
}
