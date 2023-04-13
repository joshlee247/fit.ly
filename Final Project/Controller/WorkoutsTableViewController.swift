//
//  Wokrouts2TableViewController.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import UIKit

class WorkoutsTableViewController: UITableViewController, UISearchResultsUpdating {
    var routine: ExerciseList?

    let model = ExerciseModel.shared
    let searchController = UISearchController(searchResultsController: nil)
    var filteredExercises: [Exercise]?
    let user = User.sharedInstance
    
    func loadExercises() {
        model.getExercises(onSuccess: { exercises in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.model.exercises = exercises
            }
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredExercises = model.exercises.filter { exercise in
                return exercise.name.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredExercises = model.exercises
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadExercises()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        tableView.tableHeaderView = searchController.searchBar
        filteredExercises = model.exercises
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        let firstLetters = Set(model.exercises.map { $0.name.prefix(1) })
//        return firstLetters.count
        return 1
    }

    // Return numbers of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let firstLetters = Set(model.exercises.map { String($0.name.prefix(1)) })
//        let firstLetter = Array(firstLetters).sorted()[section]
//        let itemsInSection = model.exercises.filter { String($0.name.prefix(1)) == firstLetter }
        if let filtered = filteredExercises {
            return filtered.count
        }
        return model.numberOfExercises()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        let firstLetters = Set(model.exercises.map { String($0.name.prefix(1).uppercased()) })
        let firstLetter = Array(firstLetters).sorted()[indexPath.section]
        let itemsInSection = model.exercises.filter { String($0.name.prefix(1).uppercased()) == firstLetter }
//        let item = itemsInSection[indexPath.row]
        
        if let filtered = filteredExercises {
            let exercise = filtered[indexPath.row]
            cell.textLabel?.text = exercise.name
        }
    
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if let cell = tableView.cellForRow(at: indexPath) {
//            self.performSegue(withIdentifier: "ExerciseDetailSegue", sender: cell)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            cell.accessoryType = .none
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let filtered = filteredExercises {
                routine?.workout.routines.removeAll(where: {$0.exercise.name == filtered[indexPath.row].name})
            }
        }
    }

    func resetChecks() {
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("selecting row")
        if let cell = tableView.cellForRow(at: indexPath) {
            if let filtered = filteredExercises {
                let exercise = filtered[indexPath.row]
                if !routine!.workout.routines.contains(where: { $0.exercise.name == exercise.name }) {
                    let size = routine!.workout.routines.count
                    routine?.workout.routines.append(Routine(id: size, exercise: exercise, sets: 4, reps: 10, weight: 100))
                    user.save()
                    cell.accessoryType = .checkmark
                } else {
                    // Create new Alert
                    var dialogMessage = UIAlertController(title: "Alert", message: "This exercise has been added to your workout already!", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                     })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)

                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! ExerciseDetailViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        
        let selectedExercise = model.getExercise(at: selectedRow)
        detailsVC.selectedExercise = selectedExercise
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let firstLetters = Set(model.exercises.map { String($0.name.prefix(1)) })
//        let firstLetter = Array(firstLetters).sorted()[section]
//        return firstLetter
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
