//
//  PopupViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 9/2/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    var habit: Habit?
    var nameBeforeEditing = ""
    var selectedColor: UIColor?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameTextField.setLeftPaddingPoints(15)
        //nameTextField.setRightPaddingPoints(10)
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.borderColor = UIColor(hexString: "E1E2E7")?.cgColor
        nameTextField.layer.borderWidth = 1
        
        var colorButtons:[UIButton] = []
        
        for (i, color) in COLORS.enumerated() {
            let button = ColorButton(frame: CGRect.zero, mycolor: color)
            button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            button.tag = i
            colorButtons.append(button)
            view.addSubview(button)
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        }
        
        for button in colorButtons {
            colorsStackView.addArrangedSubview(button)
        }

        if let habitToEdit = habit {
            titleLabel.text = "Edit Habit"
            titleLabel.backgroundColor = UIColor(hexString: habitToEdit.color)
            nameTextField.text = habitToEdit.name
            selectedColor = UIColor(hexString: habitToEdit.color)
            for button in colorsStackView.arrangedSubviews as! [ColorButton] {
                print("habit to edit color: \(habitToEdit.color), compared to: \(COLORS[button.tag].hexValue())")
                if habitToEdit.color == COLORS[button.tag].hexValue() {
                    button.isSelected = true
                }
            }
        } else {
            selectedColor = COLORS[0]
            titleLabel.backgroundColor = COLORS[0]
            (colorsStackView.arrangedSubviews[0] as! ColorButton).isSelected = true
        }
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        selectedColor = COLORS[sender.tag]
        
        for button in colorsStackView.arrangedSubviews as! [UIButton] {
            if sender != button {
                button.isSelected = false
            }
        }
        
        titleLabel.backgroundColor = selectedColor
    }
}

extension PopupViewController: UITextFieldDelegate {
    
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

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
