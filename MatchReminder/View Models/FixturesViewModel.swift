//
//  FixturesViewModel.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import Foundation

class FixturesViewModel {
    var competitionId: String {
        didSet {
            resourcePath = "competitions/\(competitionId)/matches"
        }
    }
    var resourcePath: String {
        didSet {
            self.apiClient.path = resourcePath
        }
    }
    let apiClient: ApiClient
    
    public var matches: [Match]?
    public var dateGroupedMatches: [Dictionary<Date, [Match?]>.Element]?

    init(competitionId: String = "PL") {
        self.competitionId = competitionId
        self.resourcePath = "competitions/\(competitionId)/matches"
        self.apiClient = ApiClient(session: URLSession.shared, resourcePath: resourcePath)
    }
    
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
