//
//  SavedSlangsViewController.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import UIKit

/// Displays locally saved slang notes.
final class SavedSlangsViewController: UIViewController {
    static let savedSlangDetailSegueIdentifier = "ShowSavedSlangDetail"

    @IBOutlet weak var tableView: UITableView!

    var items: [SavedSlang] = []
    var selectedItem: SavedSlang?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        registerForThemeChanges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadSavedSlangs()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Self.savedSlangDetailSegueIdentifier,
              let detailViewController = segue.destination as? SavedSlangDetailViewController else {
            return
        }

        if let selectedItem = selectedItem {
            detailViewController.configure(with: selectedItem)
        }
        selectedItem = nil
    }

    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func reloadSavedSlangs() {
        items = SavedSlangStore.shared.loadItems()
        tableView.reloadData()
        updateBackgroundView()
    }
}
