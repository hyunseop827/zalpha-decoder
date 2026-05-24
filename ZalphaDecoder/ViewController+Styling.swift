//
//  ViewController+Styling.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

extension ViewController {

    func configureInterface() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = labelColor

        configureDynamicColors()
        configureCards()
        configureLanguageButtons()
        configureStyleButtons()
        configureDecodeButton()
        configureTextContainers()
        configureUtilityButtons()
        configureKeyboardDismissal()
    }

    func registerForThemeChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (viewController: ViewController, _) in
            viewController.configureDynamicColors()
            viewController.updateStyleSelection()
            viewController.updateShadowPaths()
        }
    }

    func configureDynamicColors() {
        view.backgroundColor = pageBackgroundColor
        scrollView.backgroundColor = pageBackgroundColor
        contentView.backgroundColor = pageBackgroundColor

        [mainCardView, inputCardView, outputCardView, notesCardView].forEach {
            $0?.backgroundColor = cardBackgroundColor
            $0?.layer.borderColor = borderColor.cgColor
        }

        inputTextView.backgroundColor = .clear
        outputTextView.backgroundColor = .clear
        inputTextView.textColor = labelColor
        outputTextView.textColor = labelColor

        styleLabel.textColor = labelColor
        [inputLanguageLabel, outputLanguageLabel, characterCountLabel, notesTitleLabel].forEach {
            $0?.textColor = secondaryLabelColor
        }
        notesBodyLabel.textColor = labelColor
        toastLabel?.backgroundColor = toastBackgroundColor
        toastLabel?.textColor = toastTextColor

        [sourceLanguageButton, targetLanguageButton].forEach {
            $0?.setTitleColor(labelColor, for: .normal)
            $0?.tintColor = accentColor
            $0?.backgroundColor = controlBackgroundColor
            $0?.layer.borderColor = borderColor.cgColor
        }

        copyButton.tintColor = labelColor
        notesIconButton.tintColor = accentColor
        navigationController?.navigationBar.tintColor = labelColor
    }

    func configureCards() {
        applyCardStyle(to: mainCardView, cornerRadius: 18, shadowOpacity: isDarkMode ? 0.12 : 0.16, shadowRadius: 9)
        applyCardStyle(to: inputCardView, cornerRadius: 12, shadowOpacity: isDarkMode ? 0.10 : 0.18, shadowRadius: 6)
        applyCardStyle(to: outputCardView, cornerRadius: 12, shadowOpacity: isDarkMode ? 0.10 : 0.18, shadowRadius: 6)
        applyCardStyle(to: notesCardView, cornerRadius: 12, shadowOpacity: isDarkMode ? 0.10 : 0.16, shadowRadius: 6)
    }

    func configureLanguageButtons() {
        [sourceLanguageButton, targetLanguageButton].forEach {
            $0?.configuration = nil
            $0?.showsMenuAsPrimaryAction = true
            $0?.changesSelectionAsPrimaryAction = false
            $0?.titleLabel?.adjustsFontSizeToFitWidth = true
            $0?.titleLabel?.minimumScaleFactor = 0.8
            $0?.contentHorizontalAlignment = .center
            $0?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
            $0?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
            $0?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
            $0?.layer.cornerRadius = 24
            $0?.layer.borderWidth = 1
            $0?.semanticContentAttribute = .forceLeftToRight
            $0?.clipsToBounds = false
            applySmallShadow(to: $0)
        }

        swapLanguageButton.configuration = nil
        swapLanguageButton.tintColor = accentColor
        swapLanguageButton.backgroundColor = controlBackgroundColor
        swapLanguageButton.layer.cornerRadius = 24
        swapLanguageButton.layer.borderWidth = 1
        swapLanguageButton.layer.borderColor = borderColor.cgColor
        applySmallShadow(to: swapLanguageButton)
    }

    func configureStyleButtons() {
        [cleanStyleButton, plainStyleButton, casualStyleButton, genZalphaStyleButton].forEach {
            $0?.configuration = nil
            $0?.titleLabel?.adjustsFontSizeToFitWidth = true
            $0?.titleLabel?.minimumScaleFactor = 0.8
            $0?.layer.cornerRadius = 17
            $0?.layer.borderWidth = 1
            $0?.clipsToBounds = false
            applySmallShadow(to: $0)
        }
    }

    func configureDecodeButton() {
        decodeButton.configuration = nil
        decodeButton.setTitleColor(.white, for: .normal)
        decodeButton.backgroundColor = accentColor
        decodeButton.layer.cornerRadius = 22
    }

    func configureTextContainers() {
        [inputTextView, outputTextView].forEach {
            $0?.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0?.textContainer.lineFragmentPadding = 0
        }
    }

    func configureUtilityButtons() {
        copyButton.configuration = nil
        notesIconButton.configuration = nil
        notesIconButton.isUserInteractionEnabled = false
    }

    func configureKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    func updateShadowPaths() {
        [mainCardView, inputCardView, outputCardView, notesCardView, sourceLanguageButton, swapLanguageButton, targetLanguageButton, cleanStyleButton, plainStyleButton, casualStyleButton, genZalphaStyleButton].forEach {
            guard let view = $0 else { return }
            view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        }
    }

    func applyCardStyle(to view: UIView, cornerRadius: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = borderColor.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = shadowRadius
        view.clipsToBounds = false
    }

    func applySmallShadow(to view: UIView?) {
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOpacity = isDarkMode ? 0.10 : 0.18
        view?.layer.shadowOffset = CGSize(width: 0, height: 2)
        view?.layer.shadowRadius = 3
    }

    var isDarkMode: Bool {
        traitCollection.userInterfaceStyle == .dark
    }

    var pageBackgroundColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0)
                : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        }
    }

    var cardBackgroundColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0)
                : UIColor.white
        }
    }

    var controlBackgroundColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
                : UIColor.white
        }
    }

    var borderColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(white: 1.0, alpha: 0.14)
                : UIColor(white: 0.0, alpha: 0.16)
        }
    }

    var labelColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
    }

    var secondaryLabelColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(white: 1.0, alpha: 0.58)
                : UIColor(white: 0.0, alpha: 0.42)
        }
    }

    var toastBackgroundColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(white: 1.0, alpha: 0.90)
                : UIColor(white: 0.0, alpha: 0.86)
        }
    }

    var toastTextColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
    }
}
