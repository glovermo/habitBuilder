//
//  AddViewController.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/9/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var goalField: UITextField!
    @IBOutlet var colorIcon: [UIButton]!
    @IBOutlet var habitIcon: [UIButton]!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var habit = Habit()
    var currentColor = "red"
    var currentColorIndex = 0
    var currentHabitIcon = "food"
    var currentHabitIconIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if habit.name == "" {
            habit.iconColor = currentColor
            habit.iconName = currentColor+currentHabitIcon
            
        }
        updateViewController()
        
        
        saveBarButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for icon in 0..<habitIcon.count {
            habitIcon[icon].imageView?.contentMode = .scaleAspectFit        }
        
        updateViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        habit.name = nameField.text ?? ""
        habit.goalTotal = Int(goalField.text ?? "0") ?? 0
        habit.iconName = currentColor+currentHabitIcon
        habit.iconColor = currentColor
//        if segue.identifier == "UnwindFromAdd" {
//            let destination = segue.destination as! ViewController
//            destination.habits.habitsArray.append(habit)
//        }
        habit.saveData { (success) in
            print(success)
            if success {
                print("Data saved")
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    func updateViewController() {
        nameField.text = habit.name
        goalField.text = "\(habit.goalTotal)"
        currentColor = habit.iconColor
        currentHabitIcon = habit.iconName
        updateCurrentColorIndex()
        updateCurrentColor()
        updateHabitIconIndex()
        updateHabitIconColor()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateCurrentColorIndex() {
        switch currentColor {
        case "red":
            currentColorIndex = 0
        case "yellow":
            currentColorIndex = 1
        case "green":
            currentColorIndex = 2
        case "blue":
            currentColorIndex = 3
        case "purple" :
            currentColorIndex = 4
        default:
            print("whoops! missing color name \(currentColor)")
            currentColorIndex = 0
        }
    }
    
    func updateCurrentColor() {
        for icon in 0..<colorIcon.count {
            if icon == currentColorIndex {
                colorIcon[currentColorIndex].setImage(UIImage(named: "\(currentColor)Selected"), for: .normal)
            } else {
                colorIcon[icon].setImage(UIImage(named: "\(colorIcon[icon].titleLabel!.text!)"), for: .normal)
            }
        }
    }
    
    func updateHabitIconIndex() {
        if currentHabitIcon.hasSuffix("food") {
            currentHabitIconIndex = 0
            currentHabitIcon = "food"
        } else if currentHabitIcon.hasSuffix("drink") {
            currentHabitIconIndex = 1
            currentHabitIcon = "drink"
        } else if currentHabitIcon.hasSuffix("gym") {
            currentHabitIconIndex = 2
            currentHabitIcon = "gym"
        } else if currentHabitIcon.hasSuffix("shower") {
            currentHabitIconIndex = 3
            currentHabitIcon = "shower"
        } else if currentHabitIcon.hasSuffix("book") {
            currentHabitIconIndex = 4
            currentHabitIcon = "book"
        } else if currentHabitIcon.hasSuffix("clean") {
            currentHabitIconIndex = 5
            currentHabitIcon = "clean"
        } else {
            print("missing habit icon name! current icon: \(currentHabitIcon)")
            currentHabitIconIndex = 0
            currentHabitIcon = "food"
        }
    }
    
    func updateHabitIconColor() {
        for icon in 0..<habitIcon.count {
            if icon == currentHabitIconIndex {
                    habitIcon[currentHabitIconIndex].setImage(UIImage(named: "\(currentColor)\(currentHabitIcon)"), for: .normal)
            } else {
                habitIcon[icon].setImage(UIImage(named: "grey\(habitIcon[icon].titleLabel!.text!)"), for: .normal)
            }
        }
    }
    
    
    @IBAction func colorIconPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentColor = "red"
        case 1:
            currentColor = "yellow"
        case 2:
            currentColor = "green"
        case 3:
            currentColor = "blue"
        case 4:
            currentColor = "purple"
        default:
            print("whoops - check colorIcon sender \(sender.tag)")
            currentColor = "grey"
        }
        currentColorIndex = sender.tag
        print("current color: \(currentColor)")
        updateCurrentColorIndex()
        updateCurrentColor()
        
        updateHabitIconColor()
        
    }
    
    @IBAction func habitIconPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentHabitIcon = "food"
        case 1:
            currentHabitIcon = "drink"
        case 2:
            currentHabitIcon = "gym"
        case 3:
            currentHabitIcon = "shower"
        case 4:
            currentHabitIcon = "book"
        case 5:
            currentHabitIcon = "clean"
        default:
            print("whoops - check colorIcon sender \(sender.tag)")
            currentHabitIcon = "food"
        }
        
        currentHabitIconIndex = sender.tag
        updateHabitIconColor()
        
    }
    
    @IBAction func nameFieldEdited(_ sender: UITextField) {
        saveBarButton.isEnabled = !(nameField.text == "")
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        print("saveBarButton pressed")
        habit.saveData { (success) in
            print(success)
            if success {
                print("Data saved")
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    


}
