//
//  FixtureViewController.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import UIKit

class FixtureViewController: UIViewController {

    private var collectionView: UICollectionView?
    
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
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(FixtureCollectionViewCell.self, forCellWithReuseIdentifier: fixtureCell)
        collectionView.register(FixtureHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: fixtureHeader)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFixtures()
    }
    
    func setUpConstraints() {
        collectionView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func loadFixtures() {
        fixturesViewModel?.loadFixtures { (result: Result<MatchesResponse, Error>) in
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
        
        let columns: CGFloat = 1
        
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
