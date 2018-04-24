//
//  ViewController.swift
//  FoodTracker
//
//  Created by Thao Doan on 4/16/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    var meal: Meal?
    
    @IBOutlet weak var rantingControlView: RatingControl!
    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var foodImage: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mealNameTextField.delegate = self
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            mealNameTextField.text   = meal.name
            foodImage.image = meal.photo
            rantingControlView.rating = meal.rating
        }
        updateSaveButtonState()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var saveButtonTapped: UIBarButtonItem!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButtonTapped.isEnabled = false
    }
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // hide the keyboard.
        mealNameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        // make sure ViewController notified when the user picks an image
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        foodImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    //Mark: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButtonTapped else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = mealNameTextField.text ?? ""
        let photo = foodImage.image
        let rating = rantingControlView.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    //MARK: Private Methods
    private func updateSaveButtonState() {
        let text = mealNameTextField.text ?? ""
        
        saveButtonTapped.isEnabled = !text.isEmpty
        
    }
}

