//
//  FixtureHeaderCollectionReusableView.swift
//  MatchReminder
//
//  Created by Lionel Smith on 05/08/2021.
//

import UIKit

class FixtureHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = fixtureHeader
    
    var date: Date? {
        didSet {
            if let date = date {
                headerLabel.text = "\(DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .none))"
            }
        }
    }
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .black
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: label.font!.pointSize, weight: .semibold)
        return label
        
    }()
    
    public func configure(date: Date? = nil) {
        self.date = date
        addSubview(headerLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.frame = bounds
    }
}
