//
//  NewHabitViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/7/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import RealmSwift

class NewHabitViewController: UIViewController {
    
    var habit: Habit?
    let realm = try! Realm()
    var newHabitDelegate: NewHabitDelegate?
    var editHabitDelegate: EditHabitDelegate?
    var selectedColor: UIColor?
    //let colors = [UIColor.flatRed, UIColor.flatNavyBlue, UIColor.flatMagenta, UIColor.flatSkyBlue, UIColor.flatMint, UIColor.flatBrown, UIColor.flatPink, UIColor.flatCoffee]
    let stackView   = UIStackView()
    
    
    var nameBeforeEditing = ""

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setStatusBarStyle(.lightContent)
        setStatusBarStyle(.lightContent)
        
        if habit == nil {
            deleteButton.isHidden = true
        } else {
            view.backgroundColor = UIColor(hexString: (habit?.color)!)
        }
        
        var colorButtons:[UIButton] = []
        
        for (i, color) in COLORS.enumerated() {
            let button = ColorButton(frame: CGRect(x: 20, y: 400, width: 20, height: 20), mycolor: color)
            button.addTarget(self, action: #selector(testButton2Tapped), for: .touchUpInside)
            button.tag = i
            colorButtons.append(button)
            view.addSubview(button)
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        }
        
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        
        for button in colorButtons {
            //let sv = UIStackView(arrangedSubviews: <#T##[UIView]#>)
            stackView.addArrangedSubview(button)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.addConstraint(NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 0))
        
        
        if let habitToEdit = habit {
            nameTextField.text = habitToEdit.name
            selectedColor = UIColor(hexString: habitToEdit.color)
            for button in stackView.arrangedSubviews as! [ColorButton] {
                print("habit to edit color: \(habitToEdit.color), compared to: \(COLORS[button.tag].hexValue())")
                if habitToEdit.color == COLORS[button.tag].hexValue() {
                    button.isSelected = true
                }
            }
        } else {
            selectedColor = COLORS[0]
            (stackView.arrangedSubviews[0] as! ColorButton).isSelected = true
        }
        
        if habit != nil {
            let leftNavItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
            navigationItem.leftBarButtonItem = leftNavItem
        } else {
            let leftNavItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
            let rightNavItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
            navigationItem.leftBarButtonItem = leftNavItem
            navigationItem.rightBarButtonItem = rightNavItem
        }
        
        
        // This makes the swipe to go back gesture work...not sure why
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        nameTextField.delegate = self
        nameTextField.setLeftPaddingPoints(20)
        //nameTextField.setRightPaddingPoints(10)
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.borderColor = UIColor(hexString: "E1E2E7")?.cgColor
        nameTextField.layer.borderWidth = 1
        
        
        deleteButton.backgroundColor = UIColor.white
        deleteButton.layer.cornerRadius = deleteButton.frame.width/2
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowRadius = 4
        deleteButton.layer.shadowOpacity = 0.4
        deleteButton.layer.shadowOffset = CGSize.zero
        deleteButton.setImage(deleteButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        //deleteButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = selectedColor
        
        //setStatusBarStyle(.lightContent)
        
        //navigationController?.setStatusBarStyle(.lightContent)
        //navigationController?.setpreferr = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //setStatusBarStyle(.default)
        
        //navigationController?.setStatusBarStyle(.default)
        //navigationController?.preferredStatusBarStyle = .default
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        get {
//            return .lightContent
//        }
//    }
    
    @objc func backTapped(_ sender: UIBarButtonItem) {
        print("back button tapped")
        DBManager.shared.updateHabit(habit!, name: nameTextField.text!, color: selectedColor)
        
        editHabitDelegate?.userEditedAHabit()
        navigationController?.popViewController(animated: true)
    }

    @objc @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        print("cancel button pressed")
        if habit != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let habitToEdit = habit {
            DBManager.shared.updateHabit(habitToEdit, name: nameTextField.text!, color: selectedColor)
            
            editHabitDelegate?.userEditedAHabit()
            dismiss(animated: true, completion: nil)
        } else {
            DBManager.shared.createHabit(name: nameTextField.text!, color: selectedColor!)

            newHabitDelegate?.userCreatedANewHabit()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func testButton2Tapped(_ sender: UIButton) {
        sender.isSelected = true
        selectedColor = COLORS[sender.tag]
        
        for button in stackView.arrangedSubviews as! [UIButton] {
            if sender != button {
                button.isSelected = false
            }
        }
        
        navigationController?.navigationBar.barTintColor = selectedColor
        view.backgroundColor = selectedColor
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete \((habit?.name)!)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        let action = UIAlertAction(title: "Delete", style: .default) { (action) in
            DBManager.shared.deleteHabit(habit: self.habit!)
            self.editHabitDelegate?.userEditedAHabit()
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

protocol NewHabitDelegate {
    func userCreatedANewHabit()
}

protocol EditHabitDelegate {
    func userEditedAHabit()
}



extension NewHabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameBeforeEditing = textField.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textField.text = nameBeforeEditing
        }
    }
}
