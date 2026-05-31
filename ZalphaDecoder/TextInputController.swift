//
//  TextInputController.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Owns input text limits, text change callbacks, and keyboard-dismiss gesture filtering.
final class TextInputController: NSObject, UITextViewDelegate, UIGestureRecognizerDelegate {
    static let maximumInputLength = 100

    private weak var inputTextView: UITextView?
    private let maximumLength: Int
    private let onTextChanged: () -> Void
    private let onNonEmptyInput: () -> Void

    init(
        inputTextView: UITextView,
        maximumLength: Int = TextInputController.maximumInputLength,
        onTextChanged: @escaping () -> Void,
        onNonEmptyInput: @escaping () -> Void
    ) {
        self.inputTextView = inputTextView
        self.maximumLength = maximumLength
        self.onTextChanged = onTextChanged
        self.onNonEmptyInput = onNonEmptyInput
        super.init()
        inputTextView.delegate = self
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let inputTextView, textView === inputTextView else { return }

        if textView.text.count > maximumLength {
            textView.text = String(textView.text.prefix(maximumLength))
        }

        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onNonEmptyInput()
        }

        onTextChanged()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let inputTextView, textView === inputTextView else { return true }
        guard let currentText = textView.text, let stringRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        guard updatedText.count > maximumLength else { return true }

        let replacedLength = currentText[stringRange].count
        let remainingCount = maximumLength - (currentText.count - replacedLength)
        guard remainingCount > 0 else { return false }

        let allowedText = String(text.prefix(remainingCount))
        textView.text = currentText.replacingCharacters(in: stringRange, with: allowedText)
        onTextChanged()
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view, let inputTextView else { return true }
        return !touchedView.isDescendant(of: inputTextView)
    }
}
