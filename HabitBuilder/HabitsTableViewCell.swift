//
//  HabitsTableViewCell.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/6/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import UIKit

class HabitsTableViewCell: UITableViewCell {

    @IBOutlet weak var habitIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var streakIcon: UIImageView!
    @IBOutlet weak var completedButton: UIButton!
    
    func configureCell(habit: Habit) {
        //MARK:- Update Goal Image
        habitIcon.image = UIImage(named: "\(habit.iconName)")
        nameLabel.text = habit.name
        goalLabel.text = "\(habit.goalCount)/\(habit.goalTotal)"
        let goalProgress = Double(habit.goalCount)/Double(habit.goalTotal)
        goalImageView.image = UIImage(named: setGoalImage(for: goalProgress))
        streakLabel.text = "\(habit.streakCount)"
        streakIcon.image = UIImage(named: setStreakIcon(for: habit.streakCount))
        completedButton.setImage(UIImage(named:setCompletedButton(for: habit.completed)), for: .normal)
    }
    
    func showCheck(habit: Habit) {
        completedButton.isHidden = false
    }
    
    func hideCheck(habit: Habit) {
        completedButton.isHidden = true
    }

}
