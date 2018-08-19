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
    var delegate: NewHabitDelegate?
    var delegate2: EditHabitDelegate?
    var selectedColor: UIColor?
    let colors = [UIColor.flatRed, UIColor.flatNavyBlue, UIColor.flatMagenta, UIColor.flatSkyBlue, UIColor.flatMint, UIColor.flatBrown, UIColor.flatPink, UIColor.flatCoffee]
    let stackView   = UIStackView()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if habit == nil {
            deleteButton.isHidden = true
        }
        
        var colorButtons:[UIButton] = []
        
        for (i, color) in colors.enumerated() {
            let button = ColorButton(frame: CGRect(x: 20, y: 400, width: 20, height: 20), mycolor: color)
            //button.color = color
            button.addTarget(self, action: #selector(testButton2Tapped), for: .touchUpInside)
            button.tag = i
            colorButtons.append(button)
            view.addSubview(button)
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        }
        
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        //stackView.spacing   = 16.0
        //stackView.distribution = UIStackViewDistribution.fill
        
        for button in colorButtons {
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
                print("habit to edit color: #\(habitToEdit.color), copmared to: \(colors[button.tag].hexValue())")
                if "#"+habitToEdit.color == colors[button.tag].hexValue() {
                    button.isSelected = true
                }
            }
        } else {
            selectedColor = colors[0]
        }
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let habitToEdit = habit {
            try! realm.write {
                habitToEdit.name = nameTextField.text!
                habitToEdit.color = (selectedColor?.hexValue())!.replacingOccurrences(of: "#", with: "")
                print((selectedColor?.hexValue())!.replacingOccurrences(of: "#", with: ""))
                delegate2?.userEditedAHabit()
                dismiss(animated: true, completion: nil)
            }
        } else {
            let newHabit = Habit()
            newHabit.name = nameTextField.text!
            newHabit.color = (selectedColor?.hexValue())!.replacingOccurrences(of: "#", with: "")
            
            try! realm.write {
                realm.add(newHabit)
                delegate?.userCreatedANewHabit()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func testButton2Tapped(_ sender: UIButton) {
        sender.isSelected = true
        selectedColor = colors[sender.tag]
        
        for button in stackView.arrangedSubviews as! [UIButton] {
            if sender != button {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete \((habit?.name)!)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        let action = UIAlertAction(title: "Delete", style: .default) { (action) in
            //what will happen when the user clicks the add item button on the alert
            do {
                try self.realm.write {
                    
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
                    let predicate = NSPredicate(format: "habit.id = %@", (self.habit?.id)!)
                    let records = self.realm.objects(Record.self).filter(predicate)
                    self.realm.delete(records)
                    
                    self.realm.delete(self.habit!)
                    self.delegate2?.userEditedAHabit()
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                print("Error saving new item: \(error)")
            }
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
