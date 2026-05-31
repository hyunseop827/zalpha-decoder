//
//  InputLanguageDetector.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import NaturalLanguage

/// Detects supported input languages for Auto mode and explicit-source mismatch checks.
enum InputLanguageDetector {

    /// Returns the explicit source language or detects one when source is Auto.
    static func resolvedSourceLanguage(for input: String, sourceLanguage: DecodeLanguage) -> DecodeLanguage? {
        guard sourceLanguage == .auto else {
            return sourceLanguage
        }

        return detectInputLanguage(input)
    }

    /// Returns a warning message when explicit source language clearly conflicts with the input.
    static func sourceLanguageMismatchMessage(for input: String, sourceLanguage: DecodeLanguage) -> String? {
        guard sourceLanguage != .auto, shouldCheckExplicitSource(for: input) else {
            return nil
        }
        guard let detectedLanguage = detectInputLanguage(input), detectedLanguage != sourceLanguage else {
            return nil
        }

        return "Input looks \(detectedLanguage.displayName). Check source language."
    }

    /// Detects Korean or English using script counts first, then NaturalLanguage as fallback.
    static func detectInputLanguage(_ input: String) -> DecodeLanguage? {
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

    /// Skips mismatch checks for very short or ambiguous input.
    private static func shouldCheckExplicitSource(for input: String) -> Bool {
        let counts = scriptCounts(in: input)
        return counts.hangul + counts.latin >= 4
    }

    /// Counts Hangul and Latin letters so short mixed input can be handled predictably.
    private static func scriptCounts(in input: String) -> (hangul: Int, latin: Int) {
        input.unicodeScalars.reduce(into: (hangul: 0, latin: 0)) { counts, scalar in
            if isHangul(scalar) {
                counts.hangul += 1
            } else if isLatinLetter(scalar) {
                counts.latin += 1
            }
        }
    }

    /// Checks whether a Unicode scalar belongs to Korean Hangul blocks.
    private static func isHangul(_ scalar: UnicodeScalar) -> Bool {
        switch scalar.value {
        case 0x1100...0x11FF, 0x3130...0x318F, 0xAC00...0xD7AF, 0xA960...0xA97F, 0xD7B0...0xD7FF:
            return true
        default:
            return false
        }
    }

    /// Checks whether a Unicode scalar is an English alphabet letter.
    private static func isLatinLetter(_ scalar: UnicodeScalar) -> Bool {
        (0x0041...0x005A).contains(scalar.value) || (0x0061...0x007A).contains(scalar.value)
    }
}
