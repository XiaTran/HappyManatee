//
//  InfoViewController.swift
//  KeepThemHappyGame
//
//  Created by Xia Tran on 04/06/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

  @IBOutlet weak var returnButton: UIButton!
  @IBOutlet weak var hardResetButton: UIButton!
  var bestScore = 0
  var scoreLabelforBest = 0
  var name: String = ""
  var scoreTotal = 0
  var level = 0
 
  
  @IBAction func returnToGameAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func hardResetAction(_ sender: Any) {
   let bestScoreDefault = UserDefaults.standard
    bestScoreDefault.set(0, forKey: "bestScore")
    bestScoreDefault.synchronize()
    let nameDefault = UserDefaults.standard
    nameDefault.removeObject(forKey: "name")
    nameDefault.synchronize()
    bestScore = 0
    print("reset bestScore")
    let levelDefault = UserDefaults.standard
    levelDefault.set(3, forKey: "level")
    levelDefault.synchronize()
    print("reset level speed")
  }
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! startPageViewController
    vc.name = name
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
