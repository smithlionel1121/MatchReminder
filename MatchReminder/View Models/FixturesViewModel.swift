//
//  FixturesViewModel.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import Foundation

class FixturesViewModel {
    var competition: Competition {
        didSet {
            resourcePath = "competitions/\(competition.id)/matches"
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

    init(competition: Competition = Competition.allCases[0]) {
        self.competition = competition
        self.resourcePath = "competitions/\(competition.id)/matches"
        self.apiClient = ApiClient(session: URLSession.shared, resourcePath: resourcePath)
        apiClient.queryParams = [URLQueryItem(name: "status", value: "SCHEDULED")]
    }
    
    func loadFixtures(completion: @escaping (Result<MatchesResponse, ApiError>) -> Void) {
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
