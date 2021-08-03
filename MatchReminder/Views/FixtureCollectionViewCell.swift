//
//  FixtureCollectionViewCell.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import UIKit

class FixtureCollectionViewCell: UICollectionViewCell {
    
    static let identifier = fixtureCell
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.addSubview(matchStackView)
        configureFixtureView()
        setFixtureViewConstraints()
    }
    
    func configureFixtureView() {
        matchStackView.axis = .horizontal
        matchStackView.spacing = 5
        
        matchStackView.addArrangedSubview(homeLabel)
        matchStackView.addArrangedSubview(versusLabel)
        matchStackView.addArrangedSubview(awayLabel)
        
        setVersusLabelConstraints()
    }
    
    func setFixtureViewConstraints() {
        matchStackView.translatesAutoresizingMaskIntoConstraints = false
        matchStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        matchStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        matchStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
    }
    
    func setVersusLabelConstraints() {
        versusLabel.translatesAutoresizingMaskIntoConstraints = false
        versusLabel.centerXAnchor.constraint(equalTo: matchStackView.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}
