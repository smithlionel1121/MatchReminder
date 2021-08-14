//
//  Match.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import Foundation

struct MatchesResponse: Decodable {
    var count: Int
    var matches: [Match]
    
}

struct Match: Decodable {
    var id: Int
    var status: String
    var utcDate: Date
    
    var homeTeam: Team
    var awayTeam: Team
    
    var winner: String?
    var homeScore: Int?
    var awayScore: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case utcDate
        
        case homeTeam
        case awayTeam
        
        case score
        
        enum scoreKeys: String, CodingKey {
            case winner
            case fullTime
            
            enum scoreTimeKeys: String, CodingKey {
                case homeTeam
                case awayTeam
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        status = try container.decode(String.self, forKey: .status)
        utcDate = try container.decode(Date.self, forKey: .utcDate)
        homeTeam = try container.decode(Team.self, forKey: .homeTeam)
        awayTeam = try container.decode(Team.self, forKey: .awayTeam)
        
        if let scoreContainer = try? container.nestedContainer(keyedBy: CodingKeys.scoreKeys.self, forKey: .score) {
            winner = try scoreContainer.decodeIfPresent(String.self, forKey: .winner)
            
            if let fullTimeContainer = try? scoreContainer.nestedContainer(keyedBy: CodingKeys.scoreKeys.scoreTimeKeys.self, forKey: .fullTime) {
                homeScore = try fullTimeContainer.decodeIfPresent(Int.self, forKey: .homeTeam)
                awayScore = try fullTimeContainer.decodeIfPresent(Int.self, forKey: .awayTeam)
            }
        }
    }
}
