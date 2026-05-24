//
//  ViewController+AI.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

extension ViewController {

    @MainActor
    func runGreetingDecode() async {
        setDecodeLoading(true)
        defer {
            setDecodeLoading(false)
        }

        do {
            outputTextView.text = try await aiService.generateGreeting()
        } catch {
            print("Firebase AI Logic decode failed:", error)
            showToast("Could not decode. Try again.")
        }
    }

    @MainActor
    func setDecodeLoading(_ isLoading: Bool) {
        isDecoding = isLoading
        decodeButton.isEnabled = !isLoading
        decodeButton.alpha = isLoading ? 0.78 : 1.0
        let title = isLoading ? "Decoding..." : "Decode"
        decodeButton.setTitle(title, for: .normal)
        decodeButton.setTitle(title, for: .disabled)
        decodeButton.setTitleColor(.white, for: .normal)
        decodeButton.setTitleColor(UIColor.white.withAlphaComponent(0.86), for: .disabled)
    }
}
