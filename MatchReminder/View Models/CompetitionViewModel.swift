//
//  CompetitionViewModel.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import Foundation
import EventKit

class CompetitionViewModel {
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

    enum CompetitionData: String, CaseIterable {
        case matches = "Matches"
        case standings = "Standings"
    }
    
    var competition: Competition {
        didSet {
            resourcePath = "competitions/\(competition.id)/\(competitionData)"
        }
    }
    
    var competitionData: CompetitionData {
        didSet {
            resourcePath = "competitions/\(competition.id)/\(competitionData)"
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
    var calendar: EKCalendar

    init(competition: Competition = Competition.allCases[0], competitionData: CompetitionData = CompetitionData.allCases[0]) {
        self.competition = competition
        self.competitionData = competitionData
        self.resourcePath = "competitions/\(competition.id)/\(competitionData)"
        self.apiClient = ApiClient(session: URLSession.shared, resourcePath: resourcePath)
        self.calendar = EKCalendar(for: .event, eventStore: eventStore)
        
        requestAccess { (authorized) in
            if authorized {
                print("Authorized")
                self.setupCalendar()
            }
        }
    }
    
    fileprivate func setupCalendar() {
        let defaults = UserDefaults.standard
        
        if let calenderIdentifier = defaults.object(forKey: calendarIdentifierKey) as? String,
           let calendar = eventStore.calendars(for: .event).first(where: { $0.calendarIdentifier == calenderIdentifier}) {
            self.calendar = calendar
            return
        }
        
        let sourcesInEventStore = eventStore.sources
        
        var calSource: EKSource?
        
        calSource = sourcesInEventStore.filter { (source: EKSource) -> Bool in
            source.sourceType == EKSourceType.calDAV
        }.first
        
        if calSource == nil {
            calSource = sourcesInEventStore.filter { (source: EKSource) -> Bool in
                source.sourceType == EKSourceType.local
            }.first
        }

        if let localSource = calSource {
            self.calendar.source = localSource
        }
        
        do {
            calendar.title = Bundle.main.displayName ?? calendarBackupName
            try eventStore.saveCalendar(calendar, commit: true)
            defaults.set(calendar.calendarIdentifier, forKey: calendarIdentifierKey)
        } catch let error {
            print("Failed calendar setup")
            print(error)
        }
    }
    
    func loadFixtures(completion: @escaping (Result<MatchesResponse, ApiError>) -> Void) {
        apiClient.fetchResource(completion: completion)
    }
    
    //
    func loadStandings(completion: @escaping (Result<StandingsResponse, ApiError>) -> Void) {
        apiClient.fetchResource(completion: completion)
    }
    //
    
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

extension CompetitionViewModel {
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
    
    private func createMatchEventTitle(match: Match) -> String {
        return "\(match.homeTeam.name) v \(match.awayTeam.name)"
    }
    
    private func createMatchEventEndDate(match: Match) -> Date {
        return Calendar.current.date(byAdding: .hour, value: 2, to: match.utcDate) ?? match.utcDate
    }
    
    func saveMatchEvent(_ match: Match, completion: (Result<String?, Error>) -> Void) {
        guard  eventAlreadyExists(event: match) == false else {
            return
        }
        
        let ekEvent = EKEvent(eventStore: self.eventStore)
        ekEvent.title = createMatchEventTitle(match: match)
        ekEvent.startDate = match.utcDate
        ekEvent.endDate = createMatchEventEndDate(match: match)
        ekEvent.calendar = self.calendar
        ekEvent.notes = self.competition.rawValue
        ekEvent.alarms = [EKAlarm(relativeOffset: -60 * 15)]
        
        do {
            try self.eventStore.save(ekEvent, span: .thisEvent)
            completion(.success(ekEvent.eventIdentifier))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteMatchEvent(_ match: Match, completion: (Result<Void, Error>) -> Void) {
        let predicate = eventStore.predicateForEvents(withStart: match.utcDate, end: createMatchEventEndDate(match: match), calendars: [calendar])
        let savedEvents = eventStore.events(matching: predicate)
        let ekEvent = savedEvents.first { $0.title == createMatchEventTitle(match: match) }
        
        if let ekEvent = ekEvent {
            do {
                try eventStore.remove(ekEvent, span: .thisEvent)
                completion(.success(Void()))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    private func eventAlreadyExists(event: EKEvent) -> Bool {
        let predicate = eventStore.predicateForEvents(withStart: event.startDate, end: event.endDate, calendars: [calendar])
        let savedEvents = eventStore.events(matching: predicate)
        
        let eventAlreadyExists = savedEvents.contains { (savedEvent) -> Bool in
            return savedEvent.title == event.title
        }
        
        return eventAlreadyExists
    }
    
    func eventAlreadyExists(event: Match) -> Bool? {
        guard isAvailable else {
            return nil
        }
        
        let predicate = eventStore.predicateForEvents(withStart: event.utcDate, end: createMatchEventEndDate(match: event), calendars: [calendar])
        let savedEvents = eventStore.events(matching: predicate)
        
        let eventAlreadyExists = savedEvents.contains { (savedEvent) -> Bool in
            return savedEvent.title == createMatchEventTitle(match: event)
        }
        
        return eventAlreadyExists
    }
}
