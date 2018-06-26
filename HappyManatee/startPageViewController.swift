//
//  startPageViewController.swift
//  KeepThemHappyGame
//
//  Created by Xia Tran on 08/06/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit
import AVFoundation

class startPageViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var manateeImage: UIImageView!
  @IBOutlet weak var nameText: UITextField!
  @IBOutlet weak var enterButton: UIButton!
  @IBOutlet weak var responseTextLabel: UILabel!
  @IBOutlet weak var startGameButton: UIButton!
  // dificulty buttons
  @IBOutlet weak var easyButton: UIButton!
  @IBOutlet weak var mediumButton: UIButton!
  @IBOutlet weak var hardButton: UIButton!
  @IBOutlet weak var chooseDifficultyLabel: UILabel!
  @IBOutlet weak var easyLabel: UILabel!
  @IBOutlet weak var mediumLabel: UILabel!
  @IBOutlet weak var hardLabel: UILabel!
  
  
  
  var name: String = ""
  var audioPlayerBackGround = AVAudioPlayer()
  var audioPlayerButton1 = AVAudioPlayer()
  var audioPlayerButton2 = AVAudioPlayer()
  var level = 0
  
  
  func completeFields() {
    enterButton.isEnabled = false
    enterButton.isHidden = true
    nameText.isHidden = true
    startGameButton.isEnabled = true
    startGameButton.alpha = 1.0
    responseTextLabel.text = "Hello! Say hello to your new pet, '\(name)'! \n Look after \(name) well or he will run away from you.\n Press the Start Game button to begin."
   }
 // }
  
  @IBAction func enterNameAction(_ sender: UIButton) {
    name = nameText.text!
    //if not completed fields
    if (nameText.text?.isEmpty ?? true) {
      nameText.resignFirstResponder()
      responseTextLabel.text = "Please enter a name for your pet manatee!"
      audioPlayerButton2.play()
    } else {
 //   completeFields()
    self.view.endEditing(true)
    nameText.resignFirstResponder()
    audioPlayerButton1.play()
    manateeImage.image = #imageLiteral(resourceName: "happy2")
      responseTextLabel.text = "Please choose a difficulty level!"
      chooseDifficultyLabel.alpha = 1
      easyLabel.alpha = 1
      mediumLabel.alpha = 1
      hardLabel.alpha = 1
      easyButton.isEnabled = true
      mediumButton.isEnabled = true
      hardButton.isEnabled = true
    
    enterButton.isEnabled = false
    enterButton.isHidden = true
    nameText.isHidden = true
    }
  }
  
  @IBAction func startGameAction(_ sender: UIButton) {
    if level == 0 {
      responseTextLabel.text = "Please don't forget to choose the dificulty level!"
      audioPlayerButton2.play()
      } else {
        let levelDefault = UserDefaults.standard
        levelDefault.set(level, forKey: "level")
        print("\(level) is the level")
        levelDefault.synchronize()
      
    performSegue(withIdentifier: "startGame", sender: nil)
    audioPlayerBackGround.stop()
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameText.delegate = self
        manateeImage.image = #imageLiteral(resourceName: "normal2")
        nameText.isHidden = false
        startGameButton.isEnabled = false
        startGameButton.alpha = 0.2
      // init toolbar
      let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
      //create left side empty space so that done button set on right side
      let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
      let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
      toolbar.setItems([flexSpace, doneBtn], animated: false)
      toolbar.sizeToFit()
      //setting toolbar as inputAccessoryView
      self.nameText.inputAccessoryView = toolbar
      
      //music set up background music
      let url = Bundle.main.url(forResource: "walking", withExtension: "mp3")
      do {
      audioPlayerBackGround = try AVAudioPlayer(contentsOf: url!)
        audioPlayerBackGround.prepareToPlay()
      }
      catch let error as NSError {
        print(error.debugDescription)
      }
      //music set up button
      let url2 = Bundle.main.url(forResource: "yeah", withExtension: "mp3")
      do {
        audioPlayerButton1 = try AVAudioPlayer(contentsOf: url2!)
        audioPlayerButton1.prepareToPlay()
      }
      catch let error as NSError {
        print(error.debugDescription)
      }
      let url3 = Bundle.main.url(forResource: "fart", withExtension: "mp3")
      do {
        audioPlayerButton2 = try AVAudioPlayer(contentsOf: url3!)
        audioPlayerButton2.prepareToPlay()
      }
      catch let error as NSError {
        print(error.debugDescription)
      }
      let levelDefault = UserDefaults.standard
      if levelDefault.value(forKey: "level") != nil {
        level = levelDefault.value(forKey: "level") as! Int
        levelDefault.synchronize()
      }
  }
  
  //done button for keyboard
  @objc func doneButtonAction(sender: AnyObject) {
    self.view.endEditing(true)
    nameText.resignFirstResponder()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    audioPlayerBackGround.play()
    audioPlayerBackGround.numberOfLoops = -1
    startGameButton.isEnabled = false
    startGameButton.alpha = 0.2
    easyButton.isEnabled = false
    mediumButton.isEnabled = false
    hardButton.isEnabled = false
    chooseDifficultyLabel.alpha = 0.1
    easyLabel.alpha = 0.1
    mediumLabel.alpha = 0.1
    hardLabel.alpha = 0.1
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
  
//choosing level
  @IBAction func easyLevelAction(_ sender: Any) {
    level = 5
    easyButton.isEnabled = false
    mediumButton.isEnabled = false
    hardButton.isEnabled = false
    easyButton.alpha = 1.0
    mediumButton.alpha = 0.2
    hardButton.alpha = 0.2
    easyLabel.alpha = 1.0
    mediumLabel.alpha = 0.0
    hardLabel.alpha = 0.0
    completeFields()
  }
  
  @IBAction func mediumLevelAction(_ sender: Any) {
    level = 3
    easyButton.isEnabled = false
    mediumButton.isEnabled = false
    hardButton.isEnabled = false
    easyButton.alpha = 0.2
    mediumButton.alpha = 1.0
    hardButton.alpha = 0.2
    easyLabel.alpha = 0.0
    mediumLabel.alpha = 1.0
    hardLabel.alpha = 0.0
    completeFields()
  }
  
  @IBAction func hardLevelAction(_ sender: Any) {
    level = 1
    easyButton.isEnabled = false
    mediumButton.isEnabled = false
    hardButton.isEnabled = false
    easyButton.alpha = 0.2
    mediumButton.alpha = 0.2
    hardButton.alpha = 1.0
    easyLabel.alpha = 0.0
    mediumLabel.alpha = 0.0
    hardLabel.alpha = 1.0
    completeFields()
  }
  
  //carry name to main game view controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! ViewController
    vc.name = name
    vc.timeDifficulty = level
  }
  
  //text field
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  func textFieldDidBeginEditing(_ textField: UITextField) {
    moveTextField(textField: textField, moveDistance: -80, up: true)
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    moveTextField(textField: textField, moveDistance: -80, up: false)
  }
  func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
    let moveDuration = 0.3
    let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
    
    UIView.beginAnimations("animateTextField", context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(moveDuration)
    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    UIView .commitAnimations()
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

}
