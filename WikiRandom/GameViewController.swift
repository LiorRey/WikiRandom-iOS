//
//  GameViewController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 12/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import Firebase
import Canvas

class GameViewController: UIViewController
{
    @IBOutlet weak var pointsBar: UINavigationBar!
    @IBOutlet weak var muteButton: UIBarButtonItem!
    @IBOutlet weak var correctBar: UILabel!
    @IBOutlet weak var cbAnimView: CSAnimationView!
    // Outlet of the height constraint of the "correct! +1" sign, in order to controll it
    @IBOutlet weak var correctHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var rndmArticleWV: UIWebView!
    // Outlet Collection of the answer buttons
    @IBOutlet var answerButtons: [BorderedButton]!
    // Outlet Collection of the animation views for the answer buttons
    @IBOutlet var abAnimViews: [CSAnimationView]!
    @IBOutlet weak var nextArtButton: UIButton!
    
    var langAbb : Language = Language.ENGLISH
    
    // The lastWikiResult that is randomly generated, which is the correct answer each turn
    var lastWikiResult : WikiResult!
    // The correct index of the lastWikiResult.
    var lastWikiResultIndex : Int!
    // Init for the background music Player
    var bgMusic = AVAudioPlayer()
    // Init for the correctSound Player
    var correctSound = AVAudioPlayer()
    // Init for the wrongSound Player
    var wrongSound = AVAudioPlayer()
    // A boolean that tells that state of the Mute/UnMute
    var volumeIsMuted : Bool = false
    // Init the userPoints int , as 0 for start
    var userPoints : Int = 0
    // Init a new instance of the DBManager
    var manager1 : DBManager? = DBManager()

    static let gameVCManager = GameViewController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Make the ScoreBar appear on the top of the WebView
        self.view.sendSubview(toBack: rndmArticleWV)
        rndmArticleWV.layer.zPosition = -1
        
        // setting the correct bar text , according to the chosen lang
        correctBar.text = setCorrectBarText()
        // sending false to the method that shows the correctBar, for the start
        self.shouldDisplayCorrect(false, animated: false)
        
        // calls the method the is responsible for showing a new Riddle to the game
        showRandomArticle()
        
        // deInit for the the DBManager instance, each time the game launches, because maybe there is a new user playes in the same phone, and the previous manager holds the details of the previous logged user
        manager1 = nil
        // then reInit it for the new user. the new manager will now hold the new user details from the firebase
        manager1 = DBManager()
        // This method is responsible for returning and displaying the current user score, and update it using firebase RealTime Tech.
        manager1?.observeScore { (rawScore) in
            self.pointsBar.topItem?.title = ("\(rawScore) \(self.setPointsBarText())")
            self.userPoints = rawScore
        }
        
        // display the text for the nextRandomArticle Button, according to the lang
        nextArtButton.setTitle(setNextRandomArticleText(), for: .normal)
        nextArtButton.titleLabel?.numberOfLines = 2
        
        // given the AVAudioPlayers the media they should play.
        do
        {
            bgMusic = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "music_background", ofType: "mp3")!))
            bgMusic.prepareToPlay()
            bgMusic.numberOfLoops = -1
            // playing the background music as soon as the game starts
            bgMusic.play()
            
            correctSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sound_correct", ofType: "mp3")!))
            correctSound.prepareToPlay()
            
            wrongSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sound_wrong", ofType: "mp3")!))
            wrongSound.prepareToPlay()
        }
            
        catch
        {
            print(error)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // that method is responsible for showing the correctBar.
    func shouldDisplayCorrect(_ should : Bool, animated : Bool = true)
    {
        correctHeightLayout.constant = should ? 21 : 0
        
        guard animated else
        {
            return
        }
        
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func showRandomArticleAction(_ sender: UIButton)
    {
        showRandomArticle()
    }
    
    // the method that responsible for showing the next random riddle to the game
    func showRandomArticle()
    {
        self.shouldDisplayCorrect(false, animated: true)
        // A manager that generates and gets 4 results of type WikiResult
        WikiConnectionManager.manager.generateResults(lang: langAbb.stringValue()) { (arr) in
            
            var arr = arr
            // getting the last of the results array
            self.lastWikiResult = arr.last!
            // if there is an image - load the image , if there is not - load default one
            self.rndmArticleWV.loadRequest(NSURLRequest(url: self.lastWikiResult.imageURL!) as URLRequest)
            
            // calling the shuffle method for the array
            arr.shuffle()

            // getting the lastWikiResult index after the shuffling(knowing where is he now)
            self.lastWikiResultIndex = arr.index(of: self.lastWikiResult)!
            
            // displaying the category options on the buttons
            for i in 0 ..< arr.count
            {
                self.answerButtons[i].setTitle(arr[i].randomCategory(), for: UIControlState.normal)
            }
            
            for button in self.answerButtons
            {
                button.backgroundColor = UIColor(red: 214, green: 215, blue: 215, alpha: 1)
                button.isEnabled = true
            }
        }
    }
    
    // setting the pointsBarText according to the chosen language
    private func setPointsBarText() -> String
    {
        switch langAbb
        {
            case .HEBREW: return "נקודות";
            case .ENGLISH: return "Points";
            case .RUSSIAN: return "Очки";
            default: return "Points";
        }
    }
    
    // setting the CorrectBarText according to the chosen language
    private func setCorrectBarText() -> String
    {
        switch langAbb
        {
            case .HEBREW: return "נכון! 1+";
            case .ENGLISH: return "Correct! +1";
            case .RUSSIAN: return "Правильно! +1";
            default: return "Correct! +1";
        }
    }
    
    // setting the NextRandomArticleText according to the chosen language
    private func setNextRandomArticleText() -> String
    {
        switch langAbb
        {
            case .HEBREW: return ">>> הערך האקראי הבא >>>";
            case .ENGLISH: return ">>> NEXT RANDOM ARTICLE >>>";
            case .RUSSIAN: return ">>> СЛЕДУЮЩАЯ СЛУЧАЙНАЯ СТАТЬЯ >>>";
            default: return ">>> NEXT RANDOM ARTICLE >>>";
        }
    }
    
    // the method that is triggered when the one of the answerButtons is clicked
    // and is responsible for checking wheter the answer is correct for this article
    // or not , and act accordingly
    @IBAction func checkAnswer(_ sender: BorderedButton)
    {
        // if the sender tag is equals the lastWikiResult(the correct answer) index:
        if sender.tag == self.lastWikiResultIndex
        {
            cbAnimView.type = CSAnimationTypePopAlpha
            cbAnimView.duration = 0.5
            cbAnimView.startCanvasAnimation()
            
            sender.backgroundColor = UIColor.green
            
            abAnimViews[sender.tag].type = CSAnimationTypePop
            abAnimViews[sender.tag].duration = 0.5
            abAnimViews[sender.tag].startCanvasAnimation()
            
            if (!volumeIsMuted)
            {
                correctSound.play()
            }
            
            manager1?.incrementMyHighscore(self.userPoints)
            self.shouldDisplayCorrect(true)
            
        }
        
        // and if not:
        else
        {
            sender.backgroundColor = UIColor.red
            abAnimViews[sender.tag].type = CSAnimationTypeShake
            abAnimViews[sender.tag].duration = 0.2
            abAnimViews[sender.tag].startCanvasAnimation()
            
            answerButtons[self.lastWikiResultIndex].backgroundColor = UIColor.green
            abAnimViews[self.lastWikiResultIndex].type = CSAnimationTypePop
            abAnimViews[self.lastWikiResultIndex].duration = 0.5
            abAnimViews[self.lastWikiResultIndex].startCanvasAnimation()
            
            if (!volumeIsMuted)
            {
                wrongSound.play()
            }
        }
        
        //load the article by his fullurl, to the webView, no matter if user is right or wrong
        self.rndmArticleWV.loadRequest(NSURLRequest(url: self.lastWikiResult.fullURL!) as URLRequest)
        
        for button in self.answerButtons
        {
            button.isEnabled = false
            button.setTitleColor(UIColor.black, for: .disabled)
        }
    }
    
    // this method is responsible for the Mute and UnMute options(play/pause) and icons
    @IBAction func switchVolumeStatus(_ sender: UIBarButtonItem)
    {
        if (!volumeIsMuted)
        {
            bgMusic.pause()
            muteButton.image = #imageLiteral(resourceName: "mute")
        }
        
        else
        {
            bgMusic.play()
            muteButton.image = #imageLiteral(resourceName: "unmute")
        }
        
        volumeIsMuted = !volumeIsMuted
    }
    
    // if the user "minimized" the game by going to the home screen of his phone or other apps:
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        bgMusic.stop()
    }
    
    @IBAction func returnToLangAction(_ sender: UIBarButtonItem)
    {
        _ = navigationController?.popViewController(animated: true)
    }
}

//the extension to an array, for the shuffling method purpose
extension Array
{
    public mutating func shuffle()
    {
        for i in stride(from: count - 1, through: 1, by: -1)
        {
            let random = Int(arc4random_uniform(UInt32(i+1)))
            if i != random
            {
                swap(&self[i], &self[random])
            }
        }
    }
}
