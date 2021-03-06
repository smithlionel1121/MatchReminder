//
//  FixtureViewController.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import UIKit

class FixtureViewController: UIViewController {

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    var competitionSelectionView = CompetitionSelectionView(frame: .zero)
    private var competitionPicker = UIPickerView()
    
    var competitionSelectionPicker: CompetitionSelectionPicker?
    
    var competitionViewModel = CompetitionViewModel()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        loadFixtures()
        
        competitionSelectionPicker = CompetitionSelectionPicker(competitionSelectionView: self.competitionSelectionView)
        configureFilterSegmentControlTitleView()
        configureCollectionView()
        configureCompetitionSelectionView()
        
        setUpConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configureFilterSegmentControlTitleView() {
        let items = CompetitionViewModel.Filter.allCases.map { $0.rawValue }
        let filterSegmentedControl = UISegmentedControl(items: items)
        filterSegmentedControl.selectedSegmentIndex = CompetitionViewModel.Filter.allCases.firstIndex {$0 == competitionViewModel.filter } ?? 0
        filterSegmentedControl.sizeToFit()
        filterSegmentedControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)
        self.navigationItem.titleView = filterSegmentedControl
    }
    
    private func configureCollectionView() {
        collectionView.register(FixtureCollectionViewCell.self, forCellWithReuseIdentifier: FixtureCollectionViewCell.identifier)
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        collectionView.register(FixtureHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FixtureHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureRefreshControl()
        
        view.addSubview(collectionView)
    }
    
    private func configureCompetitionSelectionView() {
        view.addSubview(competitionSelectionView)
        competitionPicker.delegate = competitionSelectionPicker
        competitionPicker.dataSource = competitionSelectionPicker
        
        competitionSelectionView.configure(pickerView: competitionPicker, competitionViewModel: competitionViewModel, completion: loadFixtures)
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.systemOrange
    }
    
    func setUpConstraints() {
        setUpCompetitionSelectionViewConstraints()
        setUpCollectionViewConstraints()
    }
    
    func setUpCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: competitionSelectionView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setUpCompetitionSelectionViewConstraints() {
        competitionSelectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            competitionSelectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            competitionSelectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            competitionSelectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func loadFixtures() {
        competitionViewModel.loadData { (result: Result<MatchesResponse, ApiError>) in
            switch result {
            case .success(let matchResponse):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.competitionViewModel.matches = matchResponse.matches
                    self.competitionViewModel.arrangeDates()
                    self.collectionView.setContentOffset(.zero, animated: true)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    
    @objc
    func segmentControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        competitionViewModel.filter  = CompetitionViewModel.Filter.allCases[index]
        competitionViewModel.arrangeDates()
        collectionView.setContentOffset(.zero, animated: true)
        collectionView.reloadData()
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        loadFixtures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension FixtureViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return competitionViewModel.dateGroupedMatches?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return competitionViewModel.dateGroupedMatches?[section].value.count ?? 0
    }
    
    @objc
    func toggleMatchEvent(_ sender: UIButton) {
        let convertedPoint: CGPoint = sender.convert(CGPoint.zero, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: convertedPoint)
        
        guard let indexPath = indexPath else { return }
        let cell = self.collectionView.cellForItem(at: indexPath) as! FixtureCollectionViewCell
        
        guard let eventExists = cell.eventExists, let match = cell.match else {
            cell.starButton.isHidden = true
            return
        }
        
        if eventExists {
            competitionViewModel.deleteMatchEvent(match, completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    cell.eventExists = false
                case .failure(let error):
                    print("error \(error)")
                }
            })
        } else {
            competitionViewModel.saveMatchEvent(match, completion: { (result: Result<String?, Error>) in
                switch result {
                case .success(_):
                    cell.eventExists = true
                case .failure(let error):
                    print("error \(error)")
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: FixtureBaseCollectionViewCell
        let match = competitionViewModel.dateGroupedMatches?[indexPath.section].value[indexPath.row]

        if competitionViewModel.filter == .results {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        } else {
            let fixtureCell = collectionView.dequeueReusableCell(withReuseIdentifier: FixtureCollectionViewCell.identifier, for: indexPath) as! FixtureCollectionViewCell
            fixtureCell.starButton.tag = indexPath.row
            fixtureCell.starButton.addTarget(self, action: #selector(toggleMatchEvent(_:)), for: .touchUpInside)

            if let matchEvent = match {
                fixtureCell.eventExists = competitionViewModel.eventAlreadyExists(event: matchEvent)
            }
            cell = fixtureCell
        }
        

        cell.configureCell(match: match)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: fixtureHeader, for: indexPath) as! FixtureHeaderCollectionReusableView
        header.configure(date: competitionViewModel.dateGroupedMatches?[indexPath.section].key)
        return header
    }
}

extension FixtureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat = 1
        if UIScreen.main.bounds.width >= 800  {
            if let matches = competitionViewModel.dateGroupedMatches {
                let matchNum = matches[indexPath.section].value.count
                if matchNum > 1  && !(matchNum % 2 == 1 && indexPath.row == matchNum - 1) {
                columns = 2
               }
            }
        }
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionViewWidth = collectionView.bounds.width
        let spaceBetweenCells = layout.minimumLineSpacing * (columns - 1)
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        let width: CGFloat = floor(adjustedWidth / columns)
        let height: CGFloat = 125
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
}
