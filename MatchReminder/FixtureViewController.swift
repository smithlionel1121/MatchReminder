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
    
    var fixturesViewModel: FixturesViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.title = "Fixtures"
        
        fixturesViewModel = FixturesViewModel()
        loadFixtures()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 1

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        competitionSelectionView = CompetitionSelectionView(frame: .zero)
        competitionPicker = UIPickerView()
                
        collectionView.register(FixtureCollectionViewCell.self, forCellWithReuseIdentifier: fixtureCell)
        collectionView.register(FixtureHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: fixtureHeader)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        competitionPicker.delegate = self
        competitionPicker.dataSource = self
        
        view.addSubview(competitionSelectionView)
        view.addSubview(collectionView)
        competitionSelectionView.configure(pickerView: competitionPicker, fixturesViewModel: fixturesViewModel, completion: loadFixtures)
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFixtures()
    }
    
    func setUpConstraints() {
        setUpCompetitionSelectionViewConstraints()
        setUpCollectionViewConstraints()
    }
    
    func setUpCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: competitionSelectionView.bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func setUpCompetitionSelectionViewConstraints() {
        competitionSelectionView.translatesAutoresizingMaskIntoConstraints = false
        competitionSelectionView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        competitionSelectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        competitionSelectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func loadFixtures() {
        fixturesViewModel?.loadFixtures { (result: Result<MatchesResponse, ApiError>) in
            switch result {
            case .success(let matchResponse):
              DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.fixturesViewModel?.matches = matchResponse.matches
                self.fixturesViewModel?.arrangeDates()

                self.collectionView?.reloadData()
              }
            case .failure(let error):
              print("error \(error)")
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension FixtureViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fixturesViewModel?.dateGroupedMatches?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fixturesViewModel?.dateGroupedMatches?[section].value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fixtureCell, for: indexPath) as! FixtureCollectionViewCell
        guard let matches = fixturesViewModel?.dateGroupedMatches else {
            cell.configureCell()
            return cell
        }

        cell.configureCell(match: matches[indexPath.section].value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: fixtureHeader, for: indexPath) as! FixtureHeaderCollectionReusableView
        header.configure(date: fixturesViewModel?.dateGroupedMatches?[indexPath.section].key)
        return header
    }
}

extension FixtureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat = 1
        if UIScreen.main.bounds.width >= 800  {
            if let matches = fixturesViewModel?.dateGroupedMatches {
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
        let height: CGFloat = 100
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
        loadFixtures()
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
