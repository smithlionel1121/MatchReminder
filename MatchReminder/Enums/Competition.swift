//
//  CompetitionType.swift
//  MatchReminder
//
//  Created by Lionel Smith on 09/08/2021.
//

import Foundation

enum Competition: String, CaseIterable {
    case premierLeague = "Premier League"
    case championship = "Championship"
    case laLiga = "La Liga"
    case bundesliga = "Bundesliga"
    case serieA = "Serie A"
    case ligue1 = "Ligue 1"
    case eredivisie = "Eredivisie"
    case primeriaLiga = "Primeria Liga"
    case serieABrazil = "Serie A (Brazil)"
    case championsLeague = "Champions League"
    case worldCup = "World Cup"
    case europe = "Euros"
    
    var id: String {
        switch self {
        case .premierLeague:
            return "PL"
        case .championship:
            return "ELC"
        case .laLiga:
            return "PD"
        case .bundesliga:
            return "BL1"
        case .serieA:
            return "SA"
        case .ligue1:
            return "FL1"
        case .eredivisie:
            return "DED"
        case .primeriaLiga:
            return "PPL"
        case .serieABrazil:
            return "BSA"
        case .championsLeague:
            return "CL"
        case .worldCup:
            return "WC"
        case .europe:
            return "EC"
        }
    }
}
