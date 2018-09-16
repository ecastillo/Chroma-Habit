//
//  OnboardViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 9/10/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var bottomSegment: UIView!
    @IBOutlet weak var middleSegment: UIView!
    @IBOutlet weak var topSegment: UIView!
    
    @IBOutlet weak var topHabitOuter: UIView!
    @IBOutlet weak var topHabitInner: UIView!
    @IBOutlet weak var middleHabitOuter: UIView!
    @IBOutlet weak var middleHabitInner: UIView!
    @IBOutlet weak var bottomHabitOuter: UIView!
    @IBOutlet weak var bottomHabitInner: UIView!
    
    
    @IBAction func tapButton(_ sender: UIButton) {
        let pageViewController = parent as! OnboardPageViewController
        let nextViewController = pageViewController.pageViewController(pageViewController, viewControllerAfter: self)
        pageViewController.setViewControllers([nextViewController!], direction: .forward, animated: true, completion: nil)
        pageViewController.pageControl.currentPage = 1
    }
    
    @IBOutlet var bottomSegmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet var middleSegmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topSegmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topHabitWidthConstraint: NSLayoutConstraint!
    @IBOutlet var middleHabitWidthConstraint: NSLayoutConstraint!
    @IBOutlet var bottomHabitWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor(hexString: "1980FE")?.cgColor
        calendarView.layer.cornerRadius = 4
        
        topSegmentHeightConstraint.isActive = false
        middleSegmentHeightConstraint.isActive = false
        bottomSegmentHeightConstraint.isActive = false
        
        
        topHabitOuter.layer.borderWidth = 1
        topHabitOuter.layer.borderColor = UIColor(hexString: "D9EDFB")?.cgColor
        topHabitOuter.layer.cornerRadius = 3
        middleHabitOuter.layer.borderWidth = 1
        middleHabitOuter.layer.borderColor = UIColor(hexString: "AED7FE")?.cgColor
        middleHabitOuter.layer.cornerRadius = 3
        bottomHabitOuter.layer.borderWidth = 1
        bottomHabitOuter.layer.borderColor = UIColor(hexString: "6BB4FF")?.cgColor
        bottomHabitOuter.layer.cornerRadius = 3
        
        topHabitWidthConstraint.isActive = false
        middleHabitWidthConstraint.isActive = false
        bottomHabitWidthConstraint.isActive = false
        
        cardView.layer.cornerRadius = 5
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //view.layoutIfNeeded()
    }
    
    func startAnimation() {
        let animationOptions: UIViewAnimationOptions = .curveEaseInOut
        let keyframeAnimationOptions: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.curveEaseInOut.rawValue)
        
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: [keyframeAnimationOptions, .autoreverse, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/4, animations: {
                self.topSegmentHeightConstraint.isActive = true
                self.topHabitWidthConstraint.isActive = true
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 2/10+1/5, relativeDuration: 1/4, animations: {
                self.middleSegmentHeightConstraint.isActive = true
                self.middleHabitWidthConstraint.isActive = true
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 4/10+1/5, relativeDuration: 1/4, animations: {
                self.bottomSegmentHeightConstraint.isActive = true
                self.bottomHabitWidthConstraint.isActive = true
                self.view.layoutIfNeeded()
            })
        }, completion:{ _ in
            print("I'm done!")
        })
    }
        
        
}
