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
            teamNameLabel.text = standing?.team.name
        }
    }
    
    var teamNameLabel = UILabel()
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
        contentStackView.addArrangedSubview(teamNameLabel)
        setContentStackViewConstraints()
    }
    
    func setContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
}
