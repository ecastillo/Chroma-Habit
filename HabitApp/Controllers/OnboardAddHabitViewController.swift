//
//  OnboardAddHabitViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 9/15/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class OnboardAddHabitViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isHidden = true
        
        cardView.layer.cornerRadius = 5
        
        nameTextField.delegate = self
        nameTextField.setLeftPaddingPoints(15)
        //nameTextField.setRightPaddingPoints(10)
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.borderColor = UIColor(hexString: "E1E2E7")?.cgColor
        nameTextField.layer.borderWidth = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(nameTextField.text?.isEmpty)! {
            doneButton.isHidden = false
        } else {
            doneButton.isHidden = true
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        DBManager.shared.createHabit(name: nameTextField.text!, color: COLORS[0])
        
        UserDefaults.standard.set(true, forKey: "completedOnboarding")
        
        // Reload tableview to show newly added habit
        let rootView = view.window?.rootViewController as! CalendarViewController
        rootView.tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}
