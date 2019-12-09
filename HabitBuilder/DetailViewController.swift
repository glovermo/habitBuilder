//
//  DetailViewController.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/6/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var streakIcon: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var lastComletedLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    var habit: Habit!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if habit == nil {
            habit = Habit()
        }
        
        updateUserInterface()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func updateUserInterface() {
        //MARK:- Update Images
        nameLabel.text = habit.name
        icon.image = UIImage(named: habit.iconName)
        let goalProgress = Double(habit.goalCount)/Double(habit.goalTotal)
        goalImageView.image = UIImage(named: setGoalImage(for: goalProgress))
        goalLabel.text = "Goal: \(habit.goalCount)/\(habit.goalTotal)"
        streakIcon.image = UIImage(named: setStreakIcon(for: habit.streakCount))
        streakLabel.text = "Current Streak: \(habit.streakCount)"
//        lastComletedLabel.text = "Last Completed: \(habit.lastCompletedDate)"
        completedButton.setImage(UIImage(named: setCompletedButton(for: habit.completed)), for: .normal)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
            }
        else {
                navigationController!.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        habit.saveData { (success) in
//            print(success)
//            if success {
//                print("Data saved")
//                self.leaveViewController()
//            } else {
//                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
//            }
//        }
        if segue.identifier == "EditSegue" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! AddViewController
            destination.habit = habit
        }
    }
    
    @IBAction func completedButtonPressed(_ sender: UIButton) {
        if habit.completed {
            habit.completed = false
            habit.goalCount -= 1
            habit.streakCount -= 1
            
            habit.lastCompletedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            print(habit.lastCompletedDate)
        } else {
            habit.completed = true
            habit.goalCount += 1
            habit.streakCount += 1
            habit.lastCompletedDate = Date()
            print(habit.lastCompletedDate)
        }
        
        updateUserInterface()
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        habit.saveData() { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()

    }

}
