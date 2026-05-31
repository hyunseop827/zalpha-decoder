//
//  SavedSlangDetailViewController+Examples.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Coordinates on-demand example generation for saved slang detail.
extension SavedSlangDetailViewController {

    @IBAction func generateExamplesButtonTapped(_ sender: UIButton) {
        guard !isGeneratingExamples else { return }

        guard let item else { return }
        guard item.examples.isEmpty else {
            confirmRegenerateExamples()
            return
        }

        Task {
            await generateExamples()
        }
    }

    private func confirmRegenerateExamples() {
        let alertController = UIAlertController(
            title: "Replace existing examples?",
            message: "This will remove the current examples and generate new ones.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            Task {
                await self?.generateExamples()
            }
        })
        present(alertController, animated: true)
    }

    @MainActor
    private func generateExamples() async {
        guard let item else { return }

        setExamplesLoading(true)
        defer {
            setExamplesLoading(false)
        }

        do {
            let generatedExamples = try await aiService.generateExamples(
                expression: item.sourceExpression,
                meaning: item.meanings.first ?? "",
                sourceLanguage: item.sourceLanguage
            )
            let savedExamples = generatedExamples.map {
                SavedSlangExample(
                    id: UUID(),
                    sentence: $0.sentence,
                    meaning: $0.meaning,
                    createdAt: Date()
                )
            }

            guard !savedExamples.isEmpty else {
                showToast("Could not generate examples.")
                return
            }

            guard let updatedItem = SavedSlangStore.shared.replaceExamples(savedExamples, for: item.id) else {
                showToast("Could not save examples.")
                return
            }

            self.item = updatedItem
            renderItem()

            UINotificationFeedbackGenerator().notificationOccurred(.success)
            showToast(item.examples.isEmpty ? "Examples added." : "Examples replaced.")
        } catch AIServiceError.blocked {
            print("Firebase AI Logic example generation blocked by safety filters.")
            showToast("Examples could not be generated safely.")
        } catch AIServiceError.rateLimited {
            print("Firebase AI Logic example generation rate limited.")
            showToast("Too many requests. Try again soon.")
        } catch AIServiceError.networkUnavailable {
            print("Firebase AI Logic example generation failed because the network is unavailable.")
            showToast("Check your connection and try again.")
        } catch AIServiceError.serviceUnavailable, AIServiceError.configuration {
            print("Firebase AI Logic example generation unavailable.")
            showToast("AI is temporarily unavailable.")
        } catch {
            print("Firebase AI Logic example generation failed:", error)
            showToast("Could not generate examples.")
        }
    }

    @objc func deleteExampleButtonTapped(_ sender: UIButton) {
        guard let item, exampleIDs.indices.contains(sender.tag) else { return }
        guard let updatedItem = SavedSlangStore.shared.deleteExample(id: exampleIDs[sender.tag], from: item.id) else {
            showToast("Could not delete example.")
            return
        }

        self.item = updatedItem
        renderItem()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        showToast("Example deleted.")
    }

    @MainActor
    private func setExamplesLoading(_ isLoading: Bool) {
        isGeneratingExamples = isLoading
        generateExamplesButton.isEnabled = !isLoading
        generateExamplesButton.alpha = isLoading ? 0.65 : 1
        navigationItem.rightBarButtonItems?.forEach {
            $0.isEnabled = !isLoading
        }

        if isLoading {
            view.bringSubviewToFront(examplesLoadingOverlayView)
            examplesLoadingOverlayView.isHidden = false
            examplesLoadingIndicator.startAnimating()
            UIView.animate(withDuration: 0.16) {
                self.examplesLoadingOverlayView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.16) {
                self.examplesLoadingOverlayView.alpha = 0
            } completion: { _ in
                self.examplesLoadingIndicator.stopAnimating()
                self.examplesLoadingOverlayView.isHidden = true
            }
        }
    }
}
