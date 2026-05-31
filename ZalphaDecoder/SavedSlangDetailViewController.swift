//
//  SavedSlangDetailViewController.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Storyboard-backed read-only detail view for one saved slang item.
final class SavedSlangDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var metadataLabel: UILabel!
    @IBOutlet weak var meaningsCardView: UIView!
    @IBOutlet weak var meaningsStackView: UIStackView!
    @IBOutlet weak var translationsCardView: UIView!
    @IBOutlet weak var translationsStackView: UIStackView!

    private var item: SavedSlang?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Saved Slang"
        configureDynamicColors()
        configureCards()
        registerForThemeChanges()
        renderItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateShadowPaths()
    }

    /// Sets the saved slang item that should be rendered by this detail view.
    func configure(with item: SavedSlang) {
        self.item = item

        if isViewLoaded {
            renderItem()
        }
    }

    private func registerForThemeChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (viewController: SavedSlangDetailViewController, _) in
            viewController.configureDynamicColors()
            viewController.updateShadowPaths()
        }
    }

    private func renderItem() {
        guard let item else { return }

        expressionLabel.text = item.sourceExpression
        metadataLabel.text = "Updated \(HistoryDateFormatter.shortDateTime.string(from: item.updatedAt))"
        render(values: item.meanings, in: meaningsStackView, emptyText: "No meanings saved.")
        render(values: item.translatedExpressions, in: translationsStackView, emptyText: "No translations saved.")
    }

    private func render(values: [String], in stackView: UIStackView, emptyText: String) {
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

    private func configureDynamicColors() {
        view.backgroundColor = pageBackgroundColor
        scrollView.backgroundColor = pageBackgroundColor
        contentView.backgroundColor = pageBackgroundColor
        expressionLabel.textColor = accentColor
        metadataLabel.textColor = .secondaryLabel

        [meaningsCardView, translationsCardView].forEach {
            $0?.backgroundColor = cardBackgroundColor
            $0?.layer.borderColor = borderColor.cgColor
        }
    }

    private func configureCards() {
        [meaningsCardView, translationsCardView].forEach {
            $0?.layer.cornerRadius = 14
            $0?.layer.cornerCurve = .continuous
            $0?.layer.borderWidth = 1
            $0?.layer.shadowColor = UIColor.black.cgColor
            $0?.layer.shadowOpacity = isDarkMode ? 0.08 : 0.14
            $0?.layer.shadowRadius = 6
            $0?.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
    }

    private func updateShadowPaths() {
        [meaningsCardView, translationsCardView].forEach {
            guard let view = $0 else { return }
            view.layer.shadowPath = UIBezierPath(
                roundedRect: view.bounds,
                cornerRadius: view.layer.cornerRadius
            ).cgPath
        }
    }

    private var isDarkMode: Bool {
        traitCollection.userInterfaceStyle == .dark
    }

    private var accentColor: UIColor {
        UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0)
    }

    private var pageBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1)
                : UIColor.systemGray6
        }
    }

    private var cardBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1)
                : UIColor.white
        }
    }

    private var borderColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 1, alpha: 0.13)
                : UIColor(white: 0, alpha: 0.10)
        }
    }
}
