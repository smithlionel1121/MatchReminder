//
//  FixturesViewModel.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import Foundation

class FixturesViewModel {
    let apiClient = ApiClient(session: URLSession.shared, resourcePath: "competitions/PL/matches")
    
    public var matches: [Match]?
    public var dateGroupedMatches: [Dictionary<Date, [Match?]>.Element]?

    init() {}
    
    func loadFixtures(completion: @escaping (Result<MatchesResponse, Error>) -> Void) {
        apiClient.fetchResource(completion: completion)
    }
    
    func arrangeDates() {
        guard let matches = self.matches else { return }
        var dateGroup = [Date: [Match?]]()

        matches.forEach { match in
            let day = Calendar.current.startOfDay(for: match.utcDate)
            dateGroup[day, default: [Match]()].append(match)
        }
        
        dateGroupedMatches = dateGroup.sorted { $0.key < $1.key }
    }
}
