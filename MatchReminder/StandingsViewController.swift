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
    
    private var competitionSelectionView = CompetitionSelectionView(frame: .zero)
    private var competitionPicker = UIPickerView()
    
    var competitionSelectionPicker: CompetitionSelectionPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStandings()
        
        competitionSelectionPicker = CompetitionSelectionPicker(competitionSelectionView: self.competitionSelectionView)
        configureCompetitionSelectionView()
        configureTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.reloadData()
    }
    private func configureCompetitionSelectionView() {
        view.addSubview(competitionSelectionView)
        
        competitionPicker.delegate = competitionSelectionPicker
        competitionPicker.dataSource = competitionSelectionPicker
        
        competitionSelectionView.configure(pickerView: competitionPicker, competitionViewModel: competitionViewModel, completion: loadStandings)
        setUpCompetitionSelectionViewConstraints()
    }
    func setUpCompetitionSelectionViewConstraints() {
        competitionSelectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            competitionSelectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            competitionSelectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            competitionSelectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.backgroundColor = .black
        setTableViewConstraints()
        
        tableView.register(StandingsTableViewCell.self, forCellReuseIdentifier: StandingsTableViewCell.identifier)
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: competitionSelectionView.safeAreaLayoutGuide.bottomAnchor),
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let standing = competitionViewModel.standings?[indexPath.row] else { return }

        let teamViewController = FixtureViewController()
        
        teamViewController.competitionViewModel.competitionData = .matches
        teamViewController.competitionSelectionView.competitionField.isHidden = true
        teamViewController.competitionSelectionView.competitionLabel.text = standing.team.name
        teamViewController.competitionSelectionView.competitionLabel.textAlignment = .center
        if let teamId = standing.team.id {
            teamViewController.competitionViewModel.resourcePath = "teams/\(teamId)/matches"
        }
        self.navigationController?.pushViewController(teamViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifier, for: indexPath) as! StandingsTableViewCell
        guard let standing = competitionViewModel.standings?[indexPath.row] else { return cell }
        cell.configureCell(standing: standing)
        cell.configureOrientation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = StandingsTableViewCell(style: .default, reuseIdentifier: StandingsTableViewCell.identifier)
        cell.setColourScheme(backgroundColor: .black, textColor: .white, fontWeight: .semibold)
        cell.configureCell(standing: nil)
        cell.configureOrientation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
