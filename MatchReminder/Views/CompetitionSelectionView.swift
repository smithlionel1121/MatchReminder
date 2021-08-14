//
//  CompetitionSelectionView.swift
//  MatchReminder
//
//  Created by Lionel Smith on 09/08/2021.
//

import UIKit

class CompetitionSelectionView: UIView {
    
    var fixturesViewModel: FixturesViewModel?
    var selectedCompetition: Competition?
    var completion: (() -> Void)?

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
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(pickerView: UIPickerView, fixturesViewModel: FixturesViewModel?, completion: @escaping () -> Void) {
        self.fixturesViewModel = fixturesViewModel
        self.completion = completion
        
        self.addSubview(stackView)
        competitionField.inputView = pickerView
        if let competition = fixturesViewModel?.competition {
            competitionField.text = "\(competition.rawValue)"
        }
        stackView.addArrangedSubview(competitionLabel)
        stackView.addArrangedSubview(competitionField)
        configureStackView()
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        configureCompetitionField()
        
    }
    
    func configureCompetitionField() {
        competitionField.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        competitionField.widthAnchor.constraint(greaterThanOrEqualTo: stackView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolbar.barStyle = .default
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        competitionField.inputAccessoryView = toolbar
    }
    
    @objc
    func doneButtonTapped() {
        if let competition = selectedCompetition {
            fixturesViewModel?.competition = competition
            competitionField.text = "\(competition.rawValue)"
        }
        competitionField.resignFirstResponder()
        
        guard let completion = completion else {
            return
        }
        completion()
    }
    
    @objc
    func cancelButtonTapped() {
        selectedCompetition = nil
        competitionField.resignFirstResponder()
    }
}
