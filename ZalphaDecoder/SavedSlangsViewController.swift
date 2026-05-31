//
//  SavedSlangsViewController.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Displays locally saved slang notes.
final class SavedSlangsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var items: [SavedSlang] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        registerForThemeChanges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadSavedSlangs()
    }

    private func configureTableView() {
        configureDynamicColors()
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func registerForThemeChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (viewController: SavedSlangsViewController, _) in
            viewController.configureDynamicColors()
            viewController.tableView.reloadData()
        }
    }

    private func configureDynamicColors() {
        view.backgroundColor = pageBackgroundColor
    }

    private func reloadSavedSlangs() {
        items = SavedSlangStore.shared.loadItems()
        tableView.reloadData()
        updateBackgroundView()
    }

    private func updateBackgroundView() {
        guard items.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let label = UILabel()
        label.text = "No saved slangs yet."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        tableView.backgroundView = label
    }

    private var pageBackgroundColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1)
                : UIColor.systemGray6
        }
    }
}

extension SavedSlangsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SavedSlangCell.reuseIdentifier,
            for: indexPath
        ) as? SavedSlangCell else {
            return UITableViewCell()
        }

        cell.configure(with: items[indexPath.row])
        return cell
    }
}
