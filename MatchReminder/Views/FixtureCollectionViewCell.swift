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
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var eventExists: Bool? {
        didSet {
            guard let eventExists = eventExists else { return }                
            let systemName = eventExists ? "star.fill" : "star"
            starButton.setImage(UIImage(systemName: systemName), for: .normal)
        }
    }
    
    var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
    override func configureContent() {
        contentView.addSubview(fixtureStackView)
        configureFixtureStackView()
    }
    
    override func updateMatch() {
        if let date = match?.utcDate {
            dateLabel.text = "\(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))"
        }
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
