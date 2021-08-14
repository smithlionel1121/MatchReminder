//
//  FixtureCollectionViewCell.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import UIKit

class FixtureCollectionViewCell: FixtureBaseCollectionViewCell {
    
    static let identifier = fixtureCell
    
    private var fixtureStackView = UIStackView()
    private var matchStackView = UIStackView()

    var versusLabel: UILabel = {
        let label = UILabel()
        label.text = "v"
        label.textAlignment = .center
        return label
    }()
    
    override func configureContent() {
        contentView.addSubview(fixtureStackView)
        configureFixtureStackView()
    }
    
    func configureFixtureStackView() {
        fixtureStackView.axis = .vertical
        fixtureStackView.spacing = 10
        
        fixtureStackView.addArrangedSubview(matchStackView)
        fixtureStackView.addArrangedSubview(dateLabel)
                
        setFixtureStackViewConstraints()
        configureMatchView()
    }
    
    
    func configureMatchView() {
        matchStackView.axis = .horizontal
        matchStackView.spacing = 5
        
        homeLabel.textAlignment = .right
        awayLabel.textAlignment = .left
                
        matchStackView.addArrangedSubview(homeLabel)
        matchStackView.addArrangedSubview(versusLabel)
        matchStackView.addArrangedSubview(awayLabel)
        
        setVersusLabelConstraints()
    }
    
    func setFixtureStackViewConstraints() {
        fixtureStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fixtureStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            fixtureStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            fixtureStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
    func setVersusLabelConstraints() {
        versusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            versusLabel.centerXAnchor.constraint(equalTo: matchStackView.safeAreaLayoutGuide.centerXAnchor),
            versusLabel.widthAnchor.constraint(equalTo: matchStackView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05)
        ])
    }
}
