//
//  SavedSlangDetailViewController+Rendering.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Renders dynamic Saved Slang detail list content into storyboard stack views.
extension SavedSlangDetailViewController {

    func renderValues(_ values: [String], in stackView: UIStackView, emptyText: String) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let visibleValues = values.prefix(8)
        guard !visibleValues.isEmpty else {
            stackView.addArrangedSubview(makeValueLabel(emptyText, isEmptyState: true))
            return
        }

        visibleValues.enumerated().forEach { index, value in
            stackView.addArrangedSubview(makeValueLabel("\(index + 1). \(value)", isEmptyState: false))
        }
    }

    private func makeValueLabel(_ text: String, isEmptyState: Bool) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: isEmptyState ? .medium : .semibold)
        label.textColor = isEmptyState ? .secondaryLabel : .label
        return label
    }
}
