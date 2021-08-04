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
    
    private var homeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home Team"
        label.textAlignment = .right
        return label
    }()
    
    private var awayLabel: UILabel = {
        let label = UILabel()
        label.text = "Away Team"
        label.textAlignment = .left
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
        label.text = "\(DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .short))"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
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
        fixtureStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        fixtureStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        fixtureStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    func setVersusLabelConstraints() {
        versusLabel.translatesAutoresizingMaskIntoConstraints = false
        versusLabel.centerXAnchor.constraint(equalTo: matchStackView.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}
