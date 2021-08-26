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
            if let teamName = standing?.team.name {
                teamNameLabel.text = teamName
            }
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
    
    var positionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    var teamNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Club"
        label.numberOfLines = 0
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
        label.text = "L"
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
    
    func configureOrientation() {
        if UIScreen.main.bounds.width < 800 {
            goalsForLabel.isHidden = true
            goalsAgainstLabel.isHidden = true
            goalDifferenceLabel.isHidden = true
        } else  {
            goalsForLabel.isHidden = false
            goalsAgainstLabel.isHidden = false
            goalDifferenceLabel.isHidden = false
        }
    }
    
    func configureCell(standing: Standing?) {
        self.standing = standing
        self.backgroundColor = .orange
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemOrange
        
        self.selectedBackgroundView = backgroundView
        contentView.addSubview(contentStackView)
        configureContentStackView()
        configureOrientation()
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
        
        let multiplier: CGFloat = 0.07
        NSLayoutConstraint.activate([
            positionLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            playedGamesLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            wonLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            drawLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            lostLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            pointsLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            goalsForLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            goalsAgainstLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier),
            goalDifferenceLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier)
        ])
    }
}

extension StandingsTableViewCell {
    func setColourScheme(backgroundColor: UIColor?, textColor: UIColor?, fontWeight: UIFont.Weight? ) {
        if let backgroundColor = backgroundColor {
            contentView.backgroundColor = backgroundColor
        }
        
        if let textColor = textColor {
            positionLabel.textColor = textColor
            teamNameLabel.textColor = textColor
            playedGamesLabel.textColor = textColor
            wonLabel.textColor = textColor
            drawLabel.textColor = textColor
            lostLabel.textColor = textColor
            pointsLabel.textColor = textColor
            goalsForLabel.textColor = textColor
            goalsAgainstLabel.textColor = textColor
            goalDifferenceLabel.textColor = textColor
        }
        
        if let fontWeight = fontWeight {
            positionLabel.font = UIFont.systemFont(ofSize: positionLabel.font!.pointSize, weight: fontWeight)
            teamNameLabel.font = UIFont.systemFont(ofSize: teamNameLabel.font!.pointSize, weight: fontWeight)
            playedGamesLabel.font = UIFont.systemFont(ofSize: playedGamesLabel.font!.pointSize, weight: fontWeight)
            wonLabel.font = UIFont.systemFont(ofSize: wonLabel.font!.pointSize, weight: fontWeight)
            drawLabel.font = UIFont.systemFont(ofSize: drawLabel.font!.pointSize, weight: fontWeight)
            lostLabel.font = UIFont.systemFont(ofSize: lostLabel.font!.pointSize, weight: fontWeight)
            pointsLabel.font = UIFont.systemFont(ofSize: pointsLabel.font!.pointSize, weight: fontWeight)
            goalsForLabel.font = UIFont.systemFont(ofSize: goalsForLabel.font!.pointSize, weight: fontWeight)
            goalsAgainstLabel.font = UIFont.systemFont(ofSize: goalsAgainstLabel.font!.pointSize, weight: fontWeight)
            goalDifferenceLabel.font = UIFont.systemFont(ofSize: goalDifferenceLabel.font!.pointSize, weight: fontWeight)
        }
    }
}
