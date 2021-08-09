//
//  FixtureCompetitionSelectionView.swift
//  MatchReminder
//
//  Created by Lionel Smith on 09/08/2021.
//

import UIKit

class CompetitionSelectionView: UIView {

    private var stackView = UIStackView()
    private var competitionLabel: UILabel = {
        let label = UILabel()
        label.text = "Competition:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: label.font!.pointSize, weight: .medium)
        return label
    }()
    
    public var competitionField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.text = "Premier League"
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(pickerView: UIPickerView) {
        self.addSubview(stackView)
        competitionField.inputView = pickerView
        stackView.addArrangedSubview(competitionLabel)
        stackView.addArrangedSubview(competitionField)
        configureStackView()
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        configureCompetitionField()
        
    }
    
    func configureCompetitionField() {
        competitionField.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        competitionField.widthAnchor.constraint(greaterThanOrEqualTo: stackView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
}
