//
//  ResultCollectionViewCell.swift
//  MatchReminder
//
//  Created by Lionel Smith on 13/08/2021.
//

import UIKit

class ResultCollectionViewCell: FixtureBaseCollectionViewCell {
    
    static let identifier = resultCell
    
    private var matchStackView = UIStackView()
    private var homeStackView = UIStackView()
    private var awayStackView = UIStackView()
    
    var homeScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    var awayScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    override func configureContent() {
        contentView.addSubview(matchStackView)
        matchStackView.addArrangedSubview(homeStackView)
        matchStackView.addArrangedSubview(awayStackView)
        configureMatchStackView()
    }
    
    override func updateMatch() {
        if let homeScore = match?.homeScore {
            homeScoreLabel.text = "\(homeScore)"
        }
        if let awayScore = match?.awayScore {
            awayScoreLabel.text = "\(awayScore)"
        }
    }
    
    func configureMatchStackView() {
        matchStackView.axis = .vertical
        matchStackView.spacing = 10
        
        setMatchStackViewConstraints()
        
        awayLabel.numberOfLines = 1
        homeLabel.numberOfLines = 1
        
        homeStackView.addArrangedSubview(homeLabel)
        homeStackView.addArrangedSubview(homeScoreLabel)
        awayStackView.addArrangedSubview(awayLabel)
        awayStackView.addArrangedSubview(awayScoreLabel)

    }
    
    func setMatchStackViewConstraints() {
        matchStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            matchStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            matchStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            matchStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            matchStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
}
