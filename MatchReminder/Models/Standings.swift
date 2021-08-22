//
//  Standings.swift
//  Match Reminder
//
//  Created by Lionel Smith on 21/08/2021.
//

import Foundation

struct StandingsResponse: Decodable {
    var standings: [Standing]
    
    struct Standing: Decodable {
        var table: [Table]
    }
}

struct Table: Decodable {
    var position: Int
    var team: Team
    var playedGames: Int
    var won: Int
    var draw: Int
    var lost: Int
    var points: Int
    var goalsFor: Int
    var goalsAgainst: Int
    var goalDifference: Int
}
