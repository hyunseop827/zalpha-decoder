//
//  SavedSlangCell.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Storyboard-backed card cell that displays one saved slang summary.
final class SavedSlangCell: UITableViewCell {
    static let reuseIdentifier = "SavedSlangCell"

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var metadataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureRuntimeStyle()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        expressionLabel.text = nil
        meaningLabel.text = nil
        translatedLabel.text = nil
        metadataLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    /// Applies the saved slang item text to the storyboard labels.
    func configure(with item: SavedSlang) {
        expressionLabel.text = item.sourceExpression
        meaningLabel.text = item.meanings.first.map { "Meaning: \($0)" } ?? "Meaning: -"
        translatedLabel.text = item.translatedExpressions.first.map { "Translated: \($0)" } ?? "Translated: -"
        metadataLabel.text = "Seen \(item.seenCount)x · Updated \(HistoryDateFormatter.shortDateTime.string(from: item.updatedAt))"
        applyDynamicColors()
    }

    private func configureRuntimeStyle() {
        cardView.layer.cornerRadius = 14
        cardView.layer.cornerCurve = .continuous
        cardView.layer.borderWidth = 1
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        applyDynamicColors()
    }

    private func applyDynamicColors() {
        cardView.backgroundColor = cardBackgroundColor
        cardView.layer.borderColor = borderColor.cgColor
        cardView.layer.shadowOpacity = isDarkMode ? 0.08 : 0.12
    }

    private var isDarkMode: Bool {
        traitCollection.userInterfaceStyle == .dark
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
