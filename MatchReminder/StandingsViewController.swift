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
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStandings()
        
        competitionSelectionPicker = CompetitionSelectionPicker(competitionSelectionView: self.competitionSelectionView)
        configureCompetitionSelectionView()
        configureTableView()
        self.navigationItem.title = "Standings"
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
    
    private func configureRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.systemOrange
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.backgroundColor = .black
        
        configureRefreshControl()
        
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
        print("Running")
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
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        loadStandings()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
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
        teamViewController.competitionSelectionView.competitionLabel.textAlignment = .center

        let label = teamViewController.competitionSelectionView.competitionLabel
        
        var formerAttributes = label.attributedText?.attributes(at: 0, effectiveRange: nil)
        let font = UIFont.systemFont(ofSize: label.font!.pointSize + 3, weight: .bold)
        
        formerAttributes?.updateValue(font, forKey: NSAttributedString.Key.font)
        formerAttributes?.updateValue(NSUnderlineStyle.single.rawValue, forKey: NSAttributedString.Key.underlineStyle)

        teamViewController.competitionSelectionView.competitionLabel.attributedText = NSAttributedString(string: standing.team.name, attributes: formerAttributes)
        
        if let teamId = standing.team.id {
            teamViewController.competitionViewModel.dataId = "\(teamId)"
            teamViewController.competitionViewModel.competitionData = .matches
            teamViewController.competitionViewModel.resourceBase = .teams
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
