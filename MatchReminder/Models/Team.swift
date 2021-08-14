//
//  Team.swift
//  MatchReminder
//
//  Created by Lionel Smith on 14/08/2021.
//

import Foundation

struct Team: Codable {
    var id: Int?
    var name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "TBD"
    }
}
