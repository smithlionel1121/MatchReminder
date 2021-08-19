//
//  FixtureCollectionViewCell.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import UIKit

class FixtureCollectionViewCell: FixtureBaseCollectionViewCell {
    
    static let identifier = fixtureCell
    
    private var contentStackView = UIStackView()
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
            starButton.isHidden = false
            let systemName = eventExists ? "star.fill" : "star"
            starButton.setImage(UIImage(systemName: systemName), for: .normal)
        }
    }
    
    var starButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        return button
    }()
    
    var starView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func configureContent() {
        contentStackView.addArrangedSubview(fixtureStackView)
        contentStackView.addArrangedSubview(starView)
        
        contentView.addSubview(contentStackView)
        configureContentStackView()
    }
    
    override func updateMatch() {
        if let date = match?.utcDate {
            dateLabel.text = "\(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))"
        }
    }
    
    func configureContentStackView() {
        contentStackView.axis = .horizontal
        
        setContentStackViewConstraints()
        configureFixtureStackView()
        configureStarView()
    }
    
    func configureStarView() {
        starView.addSubview(starButton)
        setStarViewConstraints()
        setStarButtonConstraints()
    }
    
    func configureFixtureStackView() {
        fixtureStackView.axis = .vertical
        fixtureStackView.distribution = .fillEqually
        
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
    
    func setContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
    }
    
    func setStarViewConstraints() {
        starView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            starView.leadingAnchor.constraint(equalTo: fixtureStackView.trailingAnchor),
            starView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            starView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func setStarButtonConstraints() {
        starButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starButton.centerYAnchor.constraint(equalTo: starView.safeAreaLayoutGuide.centerYAnchor),
            starButton.centerXAnchor.constraint(equalTo: starView.safeAreaLayoutGuide.centerXAnchor)
        ])
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
