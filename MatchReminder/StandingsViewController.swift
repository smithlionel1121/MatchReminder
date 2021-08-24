//
//  StandingsViewController.swift
//  Match Reminder
//
//  Created by Lionel Smith on 24/08/2021.
//

import UIKit

class StandingsViewController: UIViewController {
    
    let tableView = UITableView()
    
    let competitionViewModel = CompetitionViewModel(competitionData: .standings)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadStandings()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setTableViewConstraints()
        
        tableView.register(StandingsTableViewCell.self, forCellReuseIdentifier: StandingsTableViewCell.identifier)
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func loadStandings() {
        competitionViewModel.loadData { (result: Result<StandingsResponse, ApiError>) in
            switch result {
            case .success(let standingsResponse):            
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.competitionViewModel.standings = standingsResponse.standings[0].table
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
}

extension StandingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitionViewModel.standings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standingsCell, for: indexPath) as! StandingsTableViewCell
        guard let standing = competitionViewModel.standings?[indexPath.row] else { return cell }
        cell.textLabel?.text = "\(standing.position). \(standing.team.name)"
        return cell
    }
    
}
