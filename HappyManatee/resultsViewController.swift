//
//  resultsViewController.swift
//  KeepThemHappyGame
//
//  Created by Xia Tran on 25/05/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit

class resultsViewController: UIViewController {

  @IBOutlet weak var resultsLabel: UILabel!
  @IBOutlet weak var imageofManateeImage: UIImageView!
  @IBOutlet weak var restartButton: UIButton!
  @IBOutlet weak var streakLabel: UILabel!
  @IBOutlet weak var bestScoreLabel: UILabel!
  @IBOutlet weak var statementLabel: UILabel!
  
  var streak = 0
  var bestScore = 0
  var name: String = ""
  var manateeName: String = ""
  
  @IBAction func restartButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
        super.viewDidLoad()
    streakLabel.text = String(streak)
    bestScoreLabel.text = String(bestScore)
    manateeName = name
    }

  override func viewDidAppear(_ animated: Bool) {
  
    statementLabel.text = "\(manateeName) the manatee has run away!!\n You won't be seeing him unless you improve on your parenting skills!"
    

    UIView.animateKeyframes(
        withDuration: 3.0,
        delay: 0.0,
        animations: {
              UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 3.0, animations: {
                  self.imageofManateeImage.center.x += 80.0
                  self.imageofManateeImage.center.y -= 10.0
              })
              UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 3.0, animations: {
                  self.imageofManateeImage.alpha = 0.00
              })
        },
        completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
