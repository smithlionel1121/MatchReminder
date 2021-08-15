//
//  Bundle+DisplayName.swift
//  MatchReminder
//
//  Created by Lionel Smith on 15/08/2021.
//

import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??  object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
