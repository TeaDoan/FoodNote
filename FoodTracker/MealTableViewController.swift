//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Thao Doan on 4/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {

    var meals = [Meal]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
        else {
            // Load the sample data.
            loadSampleMeals()
        }
    
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControlViewCell.rating = meal.rating
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            meals.remove(at: indexPath.row)
            
            saveMeals()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    private func loadSampleMeals() {

        let photo1 = UIImage(named:"image1")
        let photo2 = UIImage(named:"image2")
        let photo3 = UIImage(named:"image3")

        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }

        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }

        meals += [meal1, meal2, meal3]
    }

    //Mark: Actions
    
    @IBAction func unWindToMealList(sender: UIStoryboardSegue ){
        
        if let sourceViewControler = sender.source as? MealViewController, let meal = sourceViewControler.meal{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                
                // Add a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                
            }
            
             saveMeals()
        }
      
       
    }
    
    //Mark: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for:segue,sender:sender)
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    private func saveMeals() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    }
