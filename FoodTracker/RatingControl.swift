//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Thao Doan on 4/16/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

//Interface Builder does not know anything about the contents of your rating control. To fix this, you define the control as @IBDesignable. This lets Interface Builder instantiate and draw a copy of your control directly in the canvas. Additionally, now that Interface Builder has a live copy of your control, its layout engine can properly position and size the control.


@IBDesignable class RatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }
 
    @IBInspectable var starSize : CGSize = CGSize(width: 44.0, height: 44.0){
    didSet
       {
    setButtons()
        }
        
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setButtons()
    }
    //Mark: Private methods
    
    private func setButtons() {
        
        // Load Button Images
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith:
            self.traitCollection)
        
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
    
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for  index in 0..<starCount {
        // create the button
            
        let button = UIButton()
            
            //
            // set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
        
        // cancel the default layout constranints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
        // Set the accessibility label
            
        button.accessibilityLabel = "Set \(index + 1) star rating "
            
        
        button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for:.touchUpInside)
            
        //add the button to the stack
            addArrangedSubview(button)
            // add new button the rating button array
            ratingButtons.append(button)
            
        }
        updateButtonSelectionStates()
    }
    //Mark: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.index(of: button) else {
            
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        let selectedRating = index + 1
        
        if selectedRating == rating {
            
            rating = 0
            
            
        }
        else {
            rating = selectedRating
        }
        
    }

    
      private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            // Set accessibility hint and value
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
