//
//  ViewController.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/6/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, y"
    return formatter
}()

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    
    var habits: Habits!
    
    var authUI: FUIAuth!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        habits = Habits()
        habits.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sortBasedOnSegmentPressed()
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        for habit in habits.habitsArray {
            if Calendar.current.isDateInYesterday(habit.lastCompletedDate) == false {
                habit.streakCount = 0
            }
            habit.saveData { (success) in
                if success {
                    print("Data saved")
                } else {
                    print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
                }
            }
        }
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(), FUIEmailAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            //MARK:- Fix Sign In After Cancel
            print("not signed in")
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSegue" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.habit = habits.habitsArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
//    @IBAction func completedButtonPressed(_ sender: UIButton) {
//        let selectedIndexPath = IndexPath.init(row: sender.tag, section: 0)
//        print("complete button pressed \(selectedIndexPath.row)")
//        if habits.habitsArray[selectedIndexPath.row].completed {
//            habits.habitsArray[selectedIndexPath.row].completed = false
//        } else {
//            habits.habitsArray[selectedIndexPath.row].completed = true
//        }
//        self.tableView.reloadRows(at: [(selectedIndexPath)], with: .automatic)
//    }
    
    func sortBasedOnSegmentPressed() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            habits.habitsArray.sort(by: {$0.name < $1.name})
        case 1:
            habits.habitsArray.sort(by: {$0.goalCount < $1.goalCount})
        case 2:
            habits.habitsArray.sort(by: {$0.streakCount > $1.streakCount})
        default:
            print("whoops - you should never get here. check segmented control index \(sortSegmentedControl.selectedSegmentIndex)")
        }
        tableView.reloadData()
    }
    
    @IBAction func unwindFromAddViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! AddViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            habits.habitsArray[indexPath.row] = sourceViewController.habit
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: habits.habitsArray.count, section: 0)
            habits.habitsArray.append(sourceViewController.habit)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
        tableView.reloadData()
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()
    }
    
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI.signOut()
            print("^^^ Sucessfully signed out!")
            tableView.isHidden = true
            signIn()
        } catch {
            tableView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }
    }

}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            tableView.isHidden = false
            print("*** We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - marginInsets*2, height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        //MARK:- Update Sign In Image
        logoImageView.image = UIImage(named: "potat")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.habitsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HabitsTableViewCell
        cell.configureCell(habit: habits.habitsArray[indexPath.row])
        if tableView.isEditing {
            cell.hideCheck(habit: habits.habitsArray[indexPath.row])
        } else {
            cell.showCheck(habit: habits.habitsArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            habits.habitsArray[indexPath.row].deleteData()
            habits.habitsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

