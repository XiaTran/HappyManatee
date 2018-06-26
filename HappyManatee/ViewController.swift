//
//  ViewController.swift
//  KeepThemHappyGame
//
//  Created by Xia Tran on 23/05/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import AudioToolbox

class ViewController: UIViewController, GADBannerViewDelegate {
  //banner
  @IBOutlet weak var adBanner: GADBannerView!
  
  //option buttons
  @IBOutlet weak var ballButton: UIButton!
  @IBOutlet weak var boxButton: UIButton!
  @IBOutlet weak var foodButton: UIButton!
  @IBOutlet weak var medicineButton: UIButton!
  @IBOutlet weak var poohButton: UIButton!
  @IBOutlet weak var pettingButton: UIButton!
  //needs of moomoo images
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var questionImage: UIImageView!
  //results of actions
  @IBOutlet weak var choosingResponseLabel: UILabel!
  @IBOutlet weak var concequenceLabel: UILabel!
  //score keeping
  @IBOutlet weak var streakLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var bestScoreLabel: UILabel!
  //start new game button
  @IBOutlet weak var newGameButton: UIButton!
//group button
  @IBOutlet var optionGroupButton: [UIButton]!
//lives counter images
  @IBOutlet weak var loser1: UIImageView!
  @IBOutlet weak var loser2: UIImageView!
  @IBOutlet weak var loser3: UIImageView!
  
  
  
  let questions: [String] = ["I'm hungry", "I had an accident!", "I'm annoyed and need time out", "I'm bored and need to play", "I'm ill", "I'm content"]
    let answer = ["food", "pooh", "box", "ball", "medicine","pat"]
  var correctAnswer = 0
  var currentQuestion = 0
  var scoreTotal = 0
  var streak = 0
  var bestScore = 0
  var name: String = ""
  var manateeName: String = ""
  var startPageViewController : UIViewController!
 // @objc var randomTimeNumber : UInt32 = arc4random_uniform(3) + 4
  var timer = Timer()
  var timerIsOn = false
  var timeDifficulty = 3
  @objc var timeRemaining = 3
  var audioBackGround = AVAudioPlayer()
  var audioRight = AVAudioPlayer()
  var audioWrong = AVAudioPlayer()
  var audioGameLost = AVAudioPlayer()
  var livesCounter = 3
  
  
// MARK:- questions and responses
  @objc func questionRange() {
//    print(" start of \(timeRemaining)")
//    startTimer()
      currentQuestion = Int(arc4random_uniform(UInt32(6)))
      questionLabel.text = questions[currentQuestion]
      questionLabel.textColor = UIColor.black
      concequenceLabel.text = ""
      choosingResponseLabel.text = ""

      switch currentQuestion {
      case 1:
        questionLabel.text = ("'I'm hungry'")
        questionImage.image = #imageLiteral(resourceName: "hungry2")
        correctAnswer = 1
       
      case 2:
        questionLabel.text = ("'I had an accident!'")
        questionImage.image = #imageLiteral(resourceName: "cheesy2")
        correctAnswer = 2
        
      case 3:
        questionLabel.text = ("'I feel naughty!!'")
        questionImage.image = #imageLiteral(resourceName: "hyper2")
        correctAnswer = 3
    
      case 4:
        questionLabel.text = ("'I want to play!'")
        questionImage.image = #imageLiteral(resourceName: "bored2")
        correctAnswer = 4
      
      case 5:
        questionLabel.text = ("'I'm ill'")
        questionImage.image = #imageLiteral(resourceName: "medicine2")
        correctAnswer = 5
      
      case 0:
        questionLabel.text = ("'I need attention!'")
        questionImage.image = #imageLiteral(resourceName: "attention2")
        correctAnswer = 0
      
      default:
        questionLabel.text = ("'I'm content'")
        questionImage.image = #imageLiteral(resourceName: "normal2")
        correctAnswer = 6
      }
  }
  
  //using buttons to identify if correct or not
  @objc func checkAnswer(index: Int) {
    if index == correctAnswer {
      print("right")
      self.timerIsOn = false
      self.timer.invalidate()
      audioRight.play()
      print("timer off after correct choice")
      concequenceLabel.text = ("This makes \(manateeName) very happy!")
      concequenceLabel.textColor = UIColor.red
      questionLabel.text = "'Well done!'"
      questionImage.image = #imageLiteral(resourceName: "happy2")
      shrinkAndExpand()
      view.layoutIfNeeded()
      scoreTotal += 1
      scoreLabel.text = String(scoreTotal)
      for UIButton in optionGroupButton {
        UIButton.isEnabled = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        for UIButton in self.optionGroupButton {
          UIButton.isEnabled = true
        }
        self.timer.invalidate()
        self.game()
      }
    } else {
      questionImage.image = #imageLiteral(resourceName: "wrong2")
      print("wrong")
      self.timerIsOn = false
      self.timer.invalidate()
      audioWrong.play()
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      livesCounter -= 1
      print("timer off after wrong choice")
      questionLabel.text = "'Wrong!'"
      shake(vW: questionImage)
      view.layoutIfNeeded()
      concequenceLabel.text = ("Not good enough. \(manateeName) is sad..")
      concequenceLabel.textColor = UIColor.blue
      scoreTotal -= 1
      scoreLabel.text = String(scoreTotal)
      for UIButton in optionGroupButton {
        UIButton.isEnabled = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        for UIButton in self.optionGroupButton {
          UIButton.isEnabled = true
        }
        self.timer.invalidate()
        self.game()
      }
    }
  }
 
  // MARK:- view did load
  override func viewDidLoad() {
    super.viewDidLoad()
    //request
    let request = GADRequest()
    request.testDevices = [kGADSimulatorID]
    //set up ad
    adBanner.adUnitID = "pub-3940256099942544/2934735716"
    adBanner.rootViewController = self
    adBanner.delegate = self
    adBanner.load(request)
    
    //audio set up
    //music set up background music
    let url = Bundle.main.url(forResource: "littleidea", withExtension: "mp3")
    do {
      audioBackGround = try AVAudioPlayer(contentsOf: url!)
      audioBackGround.prepareToPlay()
    }
    catch let error as NSError {
      print(error.debugDescription)
    }
    //music set up losing music
    let url2 = Bundle.main.url(forResource: "loser", withExtension: "mp3")
    do {
      audioGameLost = try AVAudioPlayer(contentsOf: url2!)
      audioGameLost.prepareToPlay()
    }
    catch let error as NSError {
      print(error.debugDescription)
    }
    //music set up wrong music
    let url3 = Bundle.main.url(forResource: "fart", withExtension: "mp3")
    do {
      audioWrong = try AVAudioPlayer(contentsOf: url3!)
      audioWrong.prepareToPlay()
    }
    catch let error as NSError {
      print(error.debugDescription)
    }
    //music set up right music
    let url4 = Bundle.main.url(forResource: "yeah", withExtension: "mp3")
    do {
      audioRight = try AVAudioPlayer(contentsOf: url4!)
      audioRight.prepareToPlay()
    }
    catch let error as NSError {
      print(error.debugDescription)
    }
    livesCounter = 3
    manateeName = name
    timerIsOn = false
    timer.invalidate()
    print("timer is off at very start")
    startReset()
    let bestScoreDefault = UserDefaults.standard
    if bestScoreDefault.value(forKey: "bestScore") != nil {
      bestScore = bestScoreDefault.value(forKey: "bestScore") as! Int
      bestScoreLabel.text = String(bestScore)
      bestScoreDefault.synchronize()
    }
    let nameDefault = UserDefaults.standard
    if nameDefault.object(forKey: "name") != nil {
      manateeName = nameDefault.object(forKey: "name") as! String
      nameDefault.set(manateeName, forKey: "name")
      nameDefault.synchronize()
    }
    for UIButton in optionGroupButton {
      UIButton.isEnabled = false
    }
  }

  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    print("ad received")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    livesCounter = 3
    loser1.alpha = 0.0
    loser2.alpha = 0.0
    loser3.alpha = 0.0
    if manateeName == "" {
    self.performSegue(withIdentifier: "initialPage", sender: self)
    }
    startReset()
    DispatchQueue.main.async {
      self.newGameButton.isHidden = false
    }
    for UIButton in optionGroupButton {
      UIButton.isEnabled = false
    }
    timerIsOn = false
     print("timer is still off after appear")
  }


  //reset begining
  func startReset() {
    scoreTotal = 0
    livesCounter = 3
    timeRemaining = timeDifficulty
    scoreLabel.text = String(0)
    choosingResponseLabel.text = "What will you do to \(manateeName)?"
    concequenceLabel.text = "\(manateeName) has feelings."
    concequenceLabel.textColor = UIColor.black
    questionLabel.text = ("'I'm content'")
    questionLabel.textColor = UIColor.black
    questionImage.image = #imageLiteral(resourceName: "normal2")
    self.questionImage.bounds = CGRect(x: 180, y: 180, width: 180, height: 180)
    self.questionImage.alpha = 1.0
    timer.invalidate()

  }

  //tracks how many correct points and compares
  func game() {
    livesLeft()
    //check and update scores
    if scoreTotal > 0 && livesCounter != 0 {
      if scoreTotal > streak {
        streak = scoreTotal
        streakLabel.text = String(streak)
      }
      startTimer()
        questionRange() }
//      else {
//        loseGame()
//      }
     else {
      if streak > bestScore {
        bestScore = streak
        bestScoreLabel.text = String(streak)
      }
    loseGame()
    }
  }
  
  //score 0, go to results and start again
  func loseGame() {
    audioBackGround.stop()
    audioGameLost.play()
    print("lose game")
    timerIsOn = false
    timer.invalidate()
    print("timer is off when you lose whole game")
    questionImage.image = #imageLiteral(resourceName: "medicine2")
    UIView.animate(
      withDuration: 2.0,
      delay: 0.5,
      options: UIViewAnimationOptions.curveEaseOut,
      animations: {
        self.questionImage.alpha = 0.0
    },
      completion: nil)
    choosingResponseLabel.text = "You've not been a great owner"
    concequenceLabel.text = "\(manateeName)'s feelings are crushed."
    concequenceLabel.textColor = UIColor.black
    questionLabel.text = ("'See you later'")
    questionLabel.textColor = UIColor.red
    for UIButton in optionGroupButton {
      UIButton.isEnabled = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      print("Inside the dispatch delay")
      self.performSegue(withIdentifier: "results", sender: nil)
      self.streak = 0
      self.streakLabel.text = String(self.streak)
      self.bestScoreTracker()
    }
    
  }
  //MARK:- Lives in the game
  func livesLeft() {
    switch livesCounter {
    case 3:
      loser1.alpha = 0.0
      loser2.alpha = 0.0
      loser3.alpha = 0.0
      
    case 2:
      loser1.alpha = 1.0
      loser2.alpha = 0.0
      loser3.alpha = 0.0
      
    case 1:
      loser1.alpha = 1.0
      loser2.alpha = 1.0
      loser3.alpha = 0.0
      
    case 0:
      loser1.alpha = 1.0
      loser2.alpha = 1.0
      loser3.alpha = 1.0
      loseGame()
      
    default:
      loser1.alpha = 0.0
      loser2.alpha = 0.0
      loser3.alpha = 0.0
    }
  }
  
   //MARK:- button pressed actions
  @IBAction func newGameAction(_ sender: UIButton) {
    timeRemaining = timeDifficulty
    startTimer()
    livesCounter = 3
    questionRange()
    DispatchQueue.main.async {
    sender.isHidden = true
    }
    for UIButton in optionGroupButton {
      UIButton.isEnabled = true
    }
    audioBackGround.currentTime = 0.0
    audioBackGround.play()
    audioBackGround.numberOfLoops = -1
  }
  
  @IBAction func infoAction(_ sender: Any) {
    audioBackGround.stop()
    timerIsOn = false
    timer.invalidate()
    print("timer is off when you go to info")
  }
  
  
 
  @IBAction func ballAction(_ sender: UIButton) {
    sender.pulsate()
    checkAnswer(index: 4)
     choosingResponseLabel.text = ("You chose to give \(manateeName) a ball to play with..")
  }
  @IBAction func boxAction(_ sender: UIButton) {
    sender.pulsate()
    checkAnswer(index: 3)
    choosingResponseLabel.text = ("You chose to put \(manateeName) into a box..")
  }
  @IBAction func foodAction(_ sender: UIButton) {
    sender.pulsate()
    checkAnswer(index: 1)
    choosingResponseLabel.text = ("You chose to give \(manateeName) food..")
  }
  @IBAction func medicineAction(_ sender: UIButton) {
    sender.pulsate()
    checkAnswer(index: 5)
    choosingResponseLabel.text = ("You chose to give \(manateeName) medicine..")
  }
  @IBAction func poohAction(_ sender: UIButton) {
    sender.pulsate()
    checkAnswer(index: 2)
    choosingResponseLabel.text = ("You chose to wipe \(manateeName)'s bum bum..")
  }
  @IBAction func pettingAction(_ sender: UIButton) {
    sender.pulsate()
    checkAnswer(index: 0)
    choosingResponseLabel.text = ("You chose to pat \(manateeName) on the head..")
  }
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK:- segue connections
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "results" {
      let vc = segue.destination as! resultsViewController
      vc.streak = streak
      vc.bestScore = bestScore
      vc.name = manateeName
    }
    else if segue.identifier == "info" {
      let vc = segue.destination as! InfoViewController
      vc.bestScore = bestScore
      vc.scoreTotal = scoreTotal
      vc.name = manateeName
      vc.level = timeDifficulty
    }
  }

  //score tracker
   func bestScoreTracker() {
    let bestScoreDefault = UserDefaults.standard
    bestScoreDefault.set(bestScore, forKey: "bestScore")
    let nameDefault = UserDefaults.standard
    nameDefault.set(manateeName, forKey: "name")
    bestScoreDefault.synchronize()
  }
  
  //timer
  
  func startTimer() {
    timeRemaining = timeDifficulty
    timer = Timer.scheduledTimer(
      timeInterval : 1,
      target: self,
      selector: #selector(timeRunning),
      userInfo: nil, repeats: true)
    timerIsOn = true
    print("timer going at \(timeRemaining)")
  }
  
  @objc func timeRunning() {
    timeRemaining -= 1
    print(timeRemaining)
    if timeRemaining > 0 {
      return
    } else
    if timeRemaining == 0 {
      timer.invalidate()
      tooSlowFunction()
    }
  }
  
  func tooSlowFunction() {
      questionImage.image = #imageLiteral(resourceName: "wrong2")
      print("wrong too slow")
    //  livesCounter -= 1
      questionLabel.text = "'slow!'"
      audioWrong.play()
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      shake(vW: questionImage)
      view.layoutIfNeeded()
      concequenceLabel.text = ("Too slow. \n\(manateeName) is sad..")
      concequenceLabel.textColor = UIColor.blue
      scoreTotal -= 1
      scoreLabel.text = String(scoreTotal)
      for UIButton in optionGroupButton {
        UIButton.isEnabled = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        for UIButton in self.optionGroupButton {
          UIButton.isEnabled = true
        }
        self.timer.invalidate()
        self.timerIsOn = false
        print("timer off after slow choice")
        self.game()
//        self.questionRange()
      }
    
  }
  
  //animations
  func shrinkAndExpand() {
    //shrink animation
  UIView.animate(
  withDuration: 0.30,
  delay: 0.0,
  animations: {
  self.questionImage.bounds = CGRect(x: 10, y: 10, width: 10, height: 10)
  },
  completion: nil)
  //expand animation
  UIView.animate(
  withDuration: 0.30,
  delay: 0.30,
  animations: {
  self.questionImage.bounds = CGRect(x: 180, y: 180, width: 180, height: 180)
  },
  completion: nil)
  }

  func shake(vW: UIView) {
    CATransaction.begin()
   //CATransaction.setCompletionBlock {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = 0.6
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    vW.layer.add(animation, forKey: "shake")
    //}
    CATransaction.commit()
  }
}

extension UIButton {
  func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.1
    pulse.fromValue = 0.9
    pulse.toValue = 1.0
    //pulse.autoreverses = true
    pulse.repeatCount = 1
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
  }
}


