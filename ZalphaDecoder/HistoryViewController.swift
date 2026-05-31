//
//  HistoryViewController.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Displays locally saved decode history records.
final class HistoryViewController: UIViewController {
    static let historyDetailSegueIdentifier = "ShowHistoryDetail"

    @IBOutlet weak var tableView: UITableView!

    var items: [HistoryItem] = []
    var selectedItem: HistoryItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        registerForThemeChanges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadHistory()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Self.historyDetailSegueIdentifier,
              let detailViewController = segue.destination as? HistoryDetailViewController else {
            return
        }

        if let selectedItem = selectedItem {
            detailViewController.configure(with: selectedItem)
        }
        selectedItem = nil
    }

    func reloadHistory() {
        items = HistoryStore.shared.loadItems()
        tableView.reloadData()
        updateBackgroundView()
    }
}

enum HistoryDateFormatter {
    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
