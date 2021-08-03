//
//  Match.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import Foundation

struct MatchesResponse: Codable {
    var count: Int
    var matches: [Match]
    
}

struct Match: Codable {
    var id: Int
    var status: String
    var utcDate: Date
    
    var homeTeam: Team
    var awayTeam: Team
    
    struct Team: Codable {
        var id: Int
        var name: String
    }
}