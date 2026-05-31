//
//  ViewController+LanguageDetection.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

/// Bridges decode screen state to the shared input language detector.
extension ViewController {

    /// Returns the explicit source language or detects one when source is Auto.
    func resolvedSourceLanguage(for input: String) -> DecodeLanguage? {
        screenModel.resolvedSourceLanguage(for: input)
    }

    /// Returns a warning message when explicit source language clearly conflicts with the input.
    func sourceLanguageMismatchMessage(for input: String) -> String? {
        screenModel.sourceLanguageMismatchMessage(for: input)
    }
}
