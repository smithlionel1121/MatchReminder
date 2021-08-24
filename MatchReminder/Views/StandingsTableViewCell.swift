//
//  StandingsTableViewCell.swift
//  Match Reminder
//
//  Created by Lionel Smith on 24/08/2021.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {
    
    static let identifier = standingsCell
    
    private var contentStackView = UIStackView()
    
    var standing: Standing? {
        didSet {
            if let position = standing?.position {
                positionLabel.text = "\(position)"
            }
            teamNameLabel.text = standing?.team.name
            if let playedGames = standing?.playedGames {
                playedGamesLabel.text = "\(playedGames)"
            }
            if let won = standing?.won {
                wonLabel.text = "\(won)"
            }
            if let draw = standing?.draw {
                drawLabel.text = "\(draw)"
            }
            if let lost = standing?.lost {
                lostLabel.text = "\(lost)"
            }
            if let points = standing?.points {
                pointsLabel.text = "\(points)"
            }
            if let goalsFor = standing?.goalsFor {
                goalsForLabel.text = "\(goalsFor)"
            }
            if let goalsAgainst = standing?.goalsAgainst {
                goalsAgainstLabel.text = "\(goalsAgainst)"
            }
            if let goalDifference = standing?.goalDifference {
                goalDifferenceLabel.text = "\(goalDifference)"
            }
        }
    }
    
    var positionLabel = UILabel()
    var teamNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Club"
        label.textAlignment = .center
        return label
    }()
    var playedGamesLabel: UILabel = {
        let label = UILabel()
        label.text = "MP"
        label.textAlignment = .center
        return label
    }()
    var wonLabel: UILabel = {
        let label = UILabel()
        label.text = "W"
        label.textAlignment = .center
        return label
    }()
    var drawLabel: UILabel = {
        let label = UILabel()
        label.text = "D"
        label.textAlignment = .center
        return label
    }()
    var lostLabel: UILabel = {
        let label = UILabel()
        label.text = "D"
        label.textAlignment = .center
        return label
    }()
    var pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "P"
        label.textAlignment = .center
        return label
    }()
    var goalsForLabel: UILabel = {
        let label = UILabel()
        label.text = "GF"
        label.textAlignment = .center
        return label
    }()
    var goalsAgainstLabel: UILabel = {
        let label = UILabel()
        label.text = "GA"
        label.textAlignment = .center
        return label
    }()
    var goalDifferenceLabel: UILabel = {
        let label = UILabel()
        label.text = "GD"
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(standing: Standing?) {
        self.standing = standing
        contentView.addSubview(contentStackView)
        configureContentStackView()
    }
    
    func configureContentStackView() {
        contentStackView.addArrangedSubview(positionLabel)
        contentStackView.addArrangedSubview(teamNameLabel)
        contentStackView.addArrangedSubview(playedGamesLabel)
        contentStackView.addArrangedSubview(wonLabel)
        contentStackView.addArrangedSubview(drawLabel)
        contentStackView.addArrangedSubview(lostLabel)
        contentStackView.addArrangedSubview(pointsLabel)
        contentStackView.addArrangedSubview(goalsForLabel)
        contentStackView.addArrangedSubview(goalsAgainstLabel)
        contentStackView.addArrangedSubview(goalDifferenceLabel)
        
        setContentStackViewConstraints()
    }
    
    func setContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
        setTeamNameLabelConstraints()
    }
    
    func setTeamNameLabelConstraints() {
        NSLayoutConstraint.activate([
            positionLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            playedGamesLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            wonLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            drawLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            lostLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            pointsLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            goalsForLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            goalsAgainstLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05),
            goalDifferenceLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.05)
        ])
    }
}
