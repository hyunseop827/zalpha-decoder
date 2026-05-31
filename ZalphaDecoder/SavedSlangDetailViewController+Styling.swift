//
//  SavedSlangDetailViewController+Styling.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Groups runtime styling for the storyboard-backed Saved Slang detail screen.
extension SavedSlangDetailViewController {

    func registerForThemeChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (viewController: SavedSlangDetailViewController, _) in
            viewController.configureDynamicColors()
            viewController.updateShadowPaths()
        }
    }

    func configureDynamicColors() {
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

    func configureCards() {
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

    func updateShadowPaths() {
        [meaningsCardView, translationsCardView].forEach {
            guard let view = $0 else { return }
            view.layer.shadowPath = UIBezierPath(
                roundedRect: view.bounds,
                cornerRadius: view.layer.cornerRadius
            ).cgPath
        }
    }

    var isDarkMode: Bool {
        traitCollection.userInterfaceStyle == .dark
    }

    var accentColor: UIColor {
        UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0)
    }

    var pageBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1)
                : UIColor.systemGray6
        }
    }

    var cardBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1)
                : UIColor.white
        }
    }

    var borderColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 1, alpha: 0.13)
                : UIColor(white: 0, alpha: 0.10)
        }
    }
}
