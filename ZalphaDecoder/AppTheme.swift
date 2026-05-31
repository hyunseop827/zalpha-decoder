//
//  AppTheme.swift
//  ZalphaDecoder
//
//  Created by Codex on 5/31/26.
//

import UIKit

/// Centralized runtime theme values used by storyboard-backed screens.
enum AppTheme {
    static let accentColor = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0)

    static let pageBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1)
            : UIColor.systemGray6
    }

    static let cardBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1)
            : UIColor.white
    }

    static let detailCardBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1)
            : UIColor.white
    }

    static let noteCardBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.16, green: 0.16, blue: 0.18, alpha: 1)
            : UIColor.systemGray6
    }

    static let exampleSurfaceBackgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.55)

    static let controlBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
            : UIColor.white
    }

    static let borderColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.13)
            : UIColor(white: 0, alpha: 0.10)
    }

    static let detailBorderColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.14)
            : UIColor(white: 0, alpha: 0.12)
    }

    static let noteBorderColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.10)
            : UIColor(white: 0, alpha: 0.08)
    }

    static let labelColor = UIColor.label
    static let secondaryLabelColor = UIColor.secondaryLabel

    static let detailSecondaryLabelColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.62)
            : UIColor(white: 0, alpha: 0.52)
    }

    static let toastBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.90)
            : UIColor(white: 0, alpha: 0.86)
    }

    static let detailToastBackgroundColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.92)
            : UIColor(white: 0.05, alpha: 0.92)
    }

    static let toastTextColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
    }

    static let loadingOverlayColor = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 0, alpha: 0.45)
            : UIColor(white: 0, alpha: 0.24)
    }

    struct Shadow {
        let lightOpacity: Float
        let darkOpacity: Float
        let radius: CGFloat
        let offset: CGSize

        func opacity(for traitCollection: UITraitCollection) -> Float {
            traitCollection.userInterfaceStyle == .dark ? darkOpacity : lightOpacity
        }
    }

    static let listCardShadow = Shadow(
        lightOpacity: 0.12,
        darkOpacity: 0.08,
        radius: 5,
        offset: CGSize(width: 0, height: 2)
    )

    static let detailCardShadow = Shadow(
        lightOpacity: 0.14,
        darkOpacity: 0.08,
        radius: 6,
        offset: CGSize(width: 0, height: 3)
    )

    static let loadingCardShadow = Shadow(
        lightOpacity: 0.14,
        darkOpacity: 0.18,
        radius: 12,
        offset: CGSize(width: 0, height: 4)
    )

    static func applyCardStyle(
        to view: UIView?,
        backgroundColor: UIColor = cardBackgroundColor,
        borderColor: UIColor = borderColor,
        cornerRadius: CGFloat = 14,
        shadow: Shadow = detailCardShadow
    ) {
        guard let view else { return }

        applySurfaceStyle(
            to: view,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            cornerRadius: cornerRadius
        )
        applyShadow(shadow, to: view)
    }

    static func applySurfaceStyle(
        to view: UIView?,
        backgroundColor: UIColor,
        borderColor: UIColor? = nil,
        cornerRadius: CGFloat,
        borderWidth: CGFloat = 1
    ) {
        guard let view else { return }

        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = borderColor == nil ? 0 : borderWidth
        view.layer.borderColor = borderColor?.cgColor
    }

    static func applyShadow(_ shadow: Shadow, to view: UIView?) {
        guard let view else { return }

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = shadow.opacity(for: view.traitCollection)
        view.layer.shadowRadius = shadow.radius
        view.layer.shadowOffset = shadow.offset
        view.clipsToBounds = false
    }

    static func updateShadowPath(for view: UIView?) {
        guard let view else { return }

        view.layer.shadowPath = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: view.layer.cornerRadius
        ).cgPath
    }

    static func updateShadowPaths(for views: [UIView?]) {
        views.forEach(updateShadowPath)
    }
}
