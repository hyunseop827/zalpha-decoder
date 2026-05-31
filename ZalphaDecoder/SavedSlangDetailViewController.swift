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

    var item: SavedSlang?
    var toastLabel: ToastLabel?
    var toastHideWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()

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

    private func renderItem() {
        guard let item else { return }

        expressionLabel.text = item.sourceExpression
        metadataLabel.text = "Updated \(HistoryDateFormatter.shortDateTime.string(from: item.updatedAt))"
        renderValues(item.meanings, in: meaningsStackView, emptyText: "No meanings saved.")
        renderValues(item.translatedExpressions, in: translationsStackView, emptyText: "No translations saved.")
    }
}
