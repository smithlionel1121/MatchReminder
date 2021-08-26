//
//  CompetitionSelectionPicker.swift
//  Match Reminder
//
//  Created by Lionel Smith on 25/08/2021.
//

import UIKit

class CompetitionSelectionPicker: NSObject {
    var competitionSelectionView: CompetitionSelectionView
    
     init(competitionSelectionView: CompetitionSelectionView) {
        self.competitionSelectionView = competitionSelectionView
        super.init()
    }
}

extension CompetitionSelectionPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Competition.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        competitionSelectionView.selectedCompetition = Competition.allCases[row]
    }

}

extension CompetitionSelectionPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Competition.allCases.count
    }
}



