//
//  DecodeLanguage.swift
//  ZalphaDecoder
//
//  Created by 김현섭 on 5/6/26.
//

/// Supported language options shown in the source and target menus.
enum DecodeLanguage: CaseIterable {
    case auto
    case english
    case korean

    var displayName: String {
        switch self {
        case .auto:
            return "Auto"
        case .english:
            return "English"
        case .korean:
            return "한국어"
        }
    }

    var oppositeConcreteLanguage: DecodeLanguage {
        self == .english ? .korean : .english
    }

    static let sourceOptions: [DecodeLanguage] = [.auto, .english, .korean]
    static let targetOptions: [DecodeLanguage] = [.english, .korean]
}
