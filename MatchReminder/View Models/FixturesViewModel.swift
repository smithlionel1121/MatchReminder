//
//  FixturesViewModel.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import Foundation
import EventKit

class FixturesViewModel {
    enum Filter: String, CaseIterable {
        case fixtures = "Fixtures"
        case results = "Results"
        
        func shouldInclude(date: Date) -> Bool {
            switch self {
            case .fixtures:
                return date > Date()
            case .results:
                return date < Date()
            }
        }
    }
    
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
    
    var matches: [Match]?
    var dateGroupedMatches: [Dictionary<Date, [Match?]>.Element]?
    
    var filter: Filter = Filter.allCases[0]
    var filteredMatches: [Match]?
    
    
    private let eventStore = EKEventStore()

    init(competition: Competition = Competition.allCases[0]) {
        self.competition = competition
        self.resourcePath = "competitions/\(competition.id)/matches"
        self.apiClient = ApiClient(session: URLSession.shared, resourcePath: resourcePath)
        requestAccess { (authorized) in
            if authorized {
                print("Authorized")
            }
        }
    }
    
    func loadFixtures(completion: @escaping (Result<MatchesResponse, ApiError>) -> Void) {
        apiClient.fetchResource(completion: completion)
    }
    
    func arrangeDates() {
        filterDates()
        guard let matches = self.filteredMatches else { return }
        var dateGroup = [Date: [Match?]]()

        matches.forEach { match in
            let day = Calendar.current.startOfDay(for: match.utcDate)
            dateGroup[day, default: [Match]()].append(match)
        }
        
        if filter == .results {
            dateGroupedMatches = dateGroup.sorted { $0.key > $1.key }
        } else {
            dateGroupedMatches = dateGroup.sorted { $0.key < $1.key }
        }
    }
    
    func filterDates() {
        guard let matches = self.matches else { return }
        filteredMatches = matches.filter { filter.shouldInclude(date: $0.utcDate) }
    }
}

extension FixturesViewModel {
    private var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    private func requestAccess(completion: @escaping (Bool) -> Void) {
        let currentStatus = EKEventStore.authorizationStatus(for: .event)
        guard currentStatus == .notDetermined else {
            completion(currentStatus == .authorized)
            return
        }
        
        eventStore.requestAccess(to: .event) { (success, Error) in
            completion(success)
        }
    }
    
    private func getMatchEvent(with id: Int, completion: (EKEvent?) -> Void) {
        guard isAvailable else {
            completion(nil)
            return
        }
        
        guard let calendarItem = eventStore.calendarItem(withIdentifier: "\(id)"), let ekEvent = calendarItem as? EKEvent else {
            completion(nil)
            return
        }
        
        completion(ekEvent)
    }
    
    func saveMatchEvent(_ match: Match, completion: (String?) -> Void) {
        guard  isAvailable else {
            return
        }
        
        getMatchEvent(with: match.id) { (ekEvent) in
            let ekEvent = ekEvent ?? EKEvent(eventStore: self.eventStore)
            ekEvent.title = "\(match.homeTeam.name) v \(match.awayTeam.name)"
            ekEvent.startDate = match.utcDate
            ekEvent.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: match.utcDate)
            ekEvent.calendar = self.eventStore.defaultCalendarForNewEvents
            ekEvent.notes = self.competition.rawValue
            
            do {
                try self.eventStore.save(ekEvent, span: .thisEvent)
                completion(ekEvent.eventIdentifier)
            } catch {
                completion(nil)
            }
        }
        
    }
    
}
