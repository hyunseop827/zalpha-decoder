//
//  SavedSlangResults.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

import Foundation

/// Result of saving a Decode Note into the saved slang list.
enum SavedSlangSaveResult {
    case saved
    case updated
    case duplicate
    case invalid

    var message: String {
        switch self {
        case .saved:
            return "Saved."
        case .updated:
            return "Already saved. Updated."
        case .duplicate:
            return "Already saved."
        case .invalid:
            return "Could not save this note."
        }
    }
}

/// Result of adding one generated example to a saved slang item.
enum SavedSlangExampleSaveResult {
    case saved(SavedSlang)
    case duplicate
    case full
    case invalid
    case notFound

    var message: String {
        switch self {
        case .saved:
            return "Example added."
        case .duplicate:
            return "Example already exists. Try again."
        case .full:
            return "Delete an example first."
        case .invalid, .notFound:
            return "Could not save example."
        }
    }
}
