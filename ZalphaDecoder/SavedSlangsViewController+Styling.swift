//
//  SavedSlangsViewController+Styling.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Groups runtime styling for the storyboard-backed Saved Slangs list.
extension SavedSlangsViewController {

    func configureTableView() {
        configureDynamicColors()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func registerForThemeChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (viewController: SavedSlangsViewController, _) in
            viewController.configureDynamicColors()
            viewController.tableView.reloadData()
        }
    }

    func configureDynamicColors() {
        view.backgroundColor = pageBackgroundColor
        toastLabel?.backgroundColor = toastBackgroundColor
        toastLabel?.textColor = toastTextColor
    }

    func updateBackgroundView() {
        guard displayedItems.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let label = UILabel()
        label.text = isSearching ? "No matching slangs." : "No saved slangs yet."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        tableView.backgroundView = label
    }

    var pageBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1)
                : UIColor.systemGray6
        }
    }

    var accentColor: UIColor {
        UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0)
    }

    var toastBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 1, alpha: 0.90)
                : UIColor(white: 0, alpha: 0.86)
        }
    }

    var toastTextColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
    }
}
