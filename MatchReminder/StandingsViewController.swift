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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCompetitionSelectionView()
        configureTableView()
        loadStandings()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.reloadData()
    }
    private func configureCompetitionSelectionView() {
        view.addSubview(competitionSelectionView)
        
        competitionPicker.delegate = self
        competitionPicker.dataSource = self
        
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

extension StandingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Competition.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        competitionSelectionView.selectedCompetition = Competition.allCases[row]
    }
}

extension StandingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Competition.allCases.count
    }
}
