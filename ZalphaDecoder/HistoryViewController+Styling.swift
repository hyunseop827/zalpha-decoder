//
//  HistoryViewController+Styling.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Groups runtime styling for the storyboard-backed History list.
extension HistoryViewController {

    func configureTableView() {
        configureDynamicColors()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func registerForThemeChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (viewController: HistoryViewController, _) in
            viewController.configureDynamicColors()
            viewController.tableView.reloadData()
        }
    }

    func configureDynamicColors() {
        view.backgroundColor = pageBackgroundColor
    }

    func updateBackgroundView() {
        guard items.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let label = UILabel()
        label.text = "No history yet."
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
}
