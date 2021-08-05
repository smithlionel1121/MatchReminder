//
//  FixtureCollectionViewCell.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import UIKit

class FixtureCollectionViewCell: UICollectionViewCell {
    
    static let identifier = fixtureCell
    
    private var fixtureStackView = UIStackView()
    private var matchStackView = UIStackView()
    
    var match: Match? {
        didSet {
            homeLabel.text = match?.homeTeam.name
            awayLabel.text = match?.awayTeam.name
            if let date = match?.utcDate {
                dateLabel.text = "\(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short))"
            }
        }
    }
    
    private var homeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    private var awayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var versusLabel: UILabel = {
        let label = UILabel()
        label.text = "v"
        label.textAlignment = .center
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(match: Match? = nil) {
        self.match = match
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
        
        matchStackView.addArrangedSubview(homeLabel)
        matchStackView.addArrangedSubview(versusLabel)
        matchStackView.addArrangedSubview(awayLabel)
        
        setVersusLabelConstraints()
    }
    
    func setFixtureStackViewConstraints() {
        fixtureStackView.translatesAutoresizingMaskIntoConstraints = false
        fixtureStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        fixtureStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        fixtureStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
    
    func setVersusLabelConstraints() {
        versusLabel.translatesAutoresizingMaskIntoConstraints = false
        versusLabel.centerXAnchor.constraint(equalTo: matchStackView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        versusLabel.widthAnchor.constraint(equalTo: matchStackView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05).isActive = true
    }
}
