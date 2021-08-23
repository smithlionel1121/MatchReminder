//
//  FixtureViewController.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import UIKit

class FixtureViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var competitionSelectionView: CompetitionSelectionView!
    private var competitionPicker: UIPickerView!
    
    var competitionViewModel: CompetitionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        competitionViewModel = CompetitionViewModel()
        loadFixtures()
        
        let items = CompetitionViewModel.Filter.allCases.map { $0.rawValue }
        let filterSegmentedControl = UISegmentedControl(items: items)
        filterSegmentedControl.selectedSegmentIndex = CompetitionViewModel.Filter.allCases.firstIndex {$0 == competitionViewModel?.filter } ?? 0
        filterSegmentedControl.sizeToFit()
        filterSegmentedControl.tintColor = .red
        filterSegmentedControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)
        self.navigationItem.titleView = filterSegmentedControl
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 1

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        competitionSelectionView = CompetitionSelectionView(frame: .zero)
        competitionPicker = UIPickerView()
                
        collectionView.register(FixtureCollectionViewCell.self, forCellWithReuseIdentifier: FixtureCollectionViewCell.identifier)
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        collectionView.register(FixtureHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FixtureHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        competitionPicker.delegate = self
        competitionPicker.dataSource = self
        
        view.addSubview(competitionSelectionView)
        view.addSubview(collectionView)
        competitionSelectionView.configure(pickerView: competitionPicker, competitionViewModel: competitionViewModel, completion: loadFixtures)
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFixtures()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
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
        competitionViewModel?.loadFixtures { (result: Result<MatchesResponse, ApiError>) in
            switch result {
            case .success(let matchResponse):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.competitionViewModel?.matches = matchResponse.matches
                    self.competitionViewModel?.arrangeDates()
                    self.collectionView.setContentOffset(.zero, animated: true)
                    self.collectionView?.reloadData()
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    
    @objc
    func segmentControlChanged(_ sender: UISegmentedControl) {
        guard let competitionViewModel = competitionViewModel else { return }
        let index = sender.selectedSegmentIndex
        competitionViewModel.filter  = CompetitionViewModel.Filter.allCases[index]
        competitionViewModel.arrangeDates()
        collectionView.setContentOffset(.zero, animated: true)
        collectionView.reloadData()
    }
}

extension FixtureViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return competitionViewModel?.dateGroupedMatches?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return competitionViewModel?.dateGroupedMatches?[section].value.count ?? 0
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
            competitionViewModel?.deleteMatchEvent(match, completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    cell.eventExists = false
                case .failure(let error):
                    print("error \(error)")
                }
            })
        } else {
            competitionViewModel?.saveMatchEvent(match, completion: { (result: Result<String?, Error>) in
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
        let match = competitionViewModel?.dateGroupedMatches?[indexPath.section].value[indexPath.row]

        if competitionViewModel?.filter == .results {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        } else {
            let fixtureCell = collectionView.dequeueReusableCell(withReuseIdentifier: FixtureCollectionViewCell.identifier, for: indexPath) as! FixtureCollectionViewCell
            fixtureCell.starButton.tag = indexPath.row
            fixtureCell.starButton.addTarget(self, action: #selector(toggleMatchEvent(_:)), for: .touchUpInside)

            if let matchEvent = match {
                fixtureCell.eventExists = competitionViewModel?.eventAlreadyExists(event: matchEvent)
            }
            cell = fixtureCell
        }
        

        cell.configureCell(match: match)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: fixtureHeader, for: indexPath) as! FixtureHeaderCollectionReusableView
        header.configure(date: competitionViewModel?.dateGroupedMatches?[indexPath.section].key)
        return header
    }
}

extension FixtureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat = 1
        if UIScreen.main.bounds.width >= 800  {
            if let matches = competitionViewModel?.dateGroupedMatches {
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

extension FixtureViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Competition.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        competitionSelectionView.selectedCompetition = Competition.allCases[row]
    }
}

extension FixtureViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Competition.allCases.count
    }
}
