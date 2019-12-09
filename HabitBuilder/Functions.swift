//
//  Functions.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/7/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import Foundation

func setGoalImage(for fraction: Double) -> String {
    switch fraction {
    case let percent where percent == 0.0:
        return "progress0"
    case let percent where percent <= 0.05:
        return "progress05"
    case let percent where percent <= 0.1:
        return "progress10"
    case let percent where percent <= 0.2:
        return "progress20"
    case let percent where percent <= 0.3:
        return "progress30"
    case let percent where percent <= 0.4:
        return "progress40"
    case let percent where percent <= 0.5:
        return "progress50"
    case let percent where percent <= 0.6:
        return "progress60"
    case let percent where percent <= 0.7:
        return "progress70"
    case let percent where percent <= 0.8:
        return "progress80"
    case let percent where percent <= 0.9:
        return "progress90"
    case let percent where percent <= 1:
        return "progress100"
    default:
        print("whoops - goal image not set. current value: \(fraction)")
        return "progress0"
    }
}

func setStreakIcon(for streak: Int) -> String {
    switch streak {
    case let num where num >= 100:
        return "streak100"
    case let num where num >= 50:
        return "streak50"
    case let num where num >= 25:
        return "streak25"
    case let num where num >= 10:
        return "streak10"
    case let num where num >= 5:
        return "streak5"
    case let num where num >= 3:
        return "streak3"
    case let num where num >= 0:
        return "streak0"
    default:
        print("whoops - streak icon not set")
        return ""
    }
}

func setCompletedButton(for completed: Bool) -> String {
    switch completed {
    case true:
        return "completed"
    case false:
        return "notCompleted"
    }
}
