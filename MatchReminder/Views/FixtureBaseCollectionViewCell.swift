//
//  FixtureBaseCollectionViewCell.swift
//  MatchReminder
//
//  Created by Lionel Smith on 13/08/2021.
//

import UIKit

class FixtureBaseCollectionViewCell: UICollectionViewCell {
        
    var match: Match? {
        didSet {
            homeLabel.text = match?.homeTeam.name
            awayLabel.text = match?.awayTeam.name
            if let date = match?.utcDate {
                dateLabel.text = "\(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))"
            }
        }
    }
    
    var homeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var awayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var dateLabel: UILabel = {
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
        self.backgroundColor = .orange
        self.match = match
        self.configureContent()
    }
    
    func configureContent() {}    
}
