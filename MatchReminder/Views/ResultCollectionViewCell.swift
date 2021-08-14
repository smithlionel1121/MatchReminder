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
    
    override func configureContent() {
        contentView.addSubview(matchStackView)
        configureMatchStackView()
    }
    
    func configureMatchStackView() {
        matchStackView.axis = .vertical
        matchStackView.spacing = 10
        
        matchStackView.addArrangedSubview(homeStackView)
        matchStackView.addArrangedSubview(awayStackView)
        
        setMatchStackViewConstraints()
        homeStackView.addArrangedSubview(homeLabel)
        awayStackView.addArrangedSubview(awayLabel)

    }
    
    func setMatchStackViewConstraints() {
        matchStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            matchStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            matchStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            matchStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
}
