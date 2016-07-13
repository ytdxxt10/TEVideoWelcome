//
//  TEViewController.swift
//  TEVideoWelcome
//
//  Created by offcn on 15/9/6.
//  Copyright (c) 2015年 Terry. All rights reserved.
//
import UIKit
import AVFoundation

class ViewController: UIViewController {
    enum currentStatus : Int {
        case freeStatus
        case loginStatus
        case signupStatus
    }
    enum buttonDirection {
        
        case buttonLeft
        case buttonRight
    }
    let leftButtonFreeTitle = "Login in"
    let leftButtonLoginTItle = "Confirm Login"
    let leftButtonSignUpTitle = "Confirm Sign up"
    
    let rightButtonFreeTitle  = "Sign up"
    let rightButtonLoginTitle = "Cancel Login"
    let rightButtonSignupTitle = "Cancel Signup"
    
    let leftButtonFreeAction = "loginClick"
    let leftButtonLoginAction = "confirmClick"
    let leftButtonSignupAction = "confirmClick"
    
    let rightButtonFreeAction = "signupClick"
    let rightButtonLoginAction = "cancelClick"
    let rightButtonSignupAction = "cancelClick"
    
    let button_padding = 20.0
    var player:AVPlayer?
    var leftButton:UIButton!
    var rightButton:UIButton!
    var status:currentStatus!
    var titleLabel:UILabel!
    var cardView:CardView = CardView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.status = currentStatus.freeStatus
        
        createVideoPlayer()
        createTitleLabel()
        createButton()
        createShowAnimation()
        
        addCardView()
        //        self.view.addSubview(cardView)
        //        createButton()
    }
    
    func createTitleLabel() {
        
        self.titleLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width-80, 80))
        self.titleLabel.alpha = 0.0
        self.titleLabel.center = self.view.center
        self.titleLabel.textAlignment = .Center
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.text = "UBER"
        self.titleLabel.textColor = UIColor(white: 1.0, alpha: 0.2)
        self.titleLabel.font = UIFont.systemFontOfSize(72)
        self.view.addSubview(self.titleLabel)
        
        
        
    }
    
    func createShowAnimation () {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 4.0
        self.titleLabel.layer.addAnimation(animation, forKey: "alpha")
        
        let keyAnimation = CAKeyframeAnimation(keyPath: "opacity")
        keyAnimation.duration = 4.0
        keyAnimation.values = [0.0,1.0,0.0]
        keyAnimation.keyTimes = [0.0,0.35,1.0]
        self.titleLabel.layer.addAnimation(keyAnimation, forKey: "opacity")
        
    }
    
    func createVideoPlayer( ){
        let path = NSBundle.mainBundle().pathForResource("welcome_video", ofType: "mp4")
        let url = NSURL(fileURLWithPath: path!)
        let playerItem : AVPlayerItem = AVPlayerItem(URL: url)
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        
        self.player = AVPlayer.init(playerItem: playerItem)
        self.player?.volume = 0.0
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = "\(UIViewContentMode.ScaleToFill)"
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        self.player?.play()
        self.player?.currentItem!.addObserver(self, forKeyPath: AVPlayerItemDidPlayToEndTimeNotification, options: NSKeyValueObservingOptions.New, context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.moviePlayDidEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player?.currentItem)
        
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
    }
    //保证视频循环播放
    func moviePlayDidEnd(notification:NSNotification) {
//        var playerItem:AVPlayerItem = notification.object as! AVPlayerItem
        player?.seekToTime(kCMTimeZero)
        self.player?.play()
        
    }
    
    func createButton() {
        self.leftButton = self.createButtonWithTitleAndIndexAndAction("Login in", index: buttonDirection.buttonLeft, action: #selector(ViewController.loginClick))
        self.view.addSubview(self.leftButton)
        self.rightButton = self.createButtonWithTitleAndIndexAndAction("Register in", index: buttonDirection.buttonRight, action: #selector(ViewController.signupClick))
        self.view.addSubview(self.rightButton)
        
    }
    func createButtonWithTitleAndIndexAndAction(title:String,index:buttonDirection,action:Selector)->UIButton {
        
        let windth:CGFloat = CGFloat((Int(self.view.frame.size.width) - Int(3*button_padding))/2)
        let button = UIButton(frame: CGRectMake(0, 0, windth, 30))
        let x:Int = Int(self.view.frame.size.width / 4)
        let y = index.hashValue * Int(self.view.frame.size.width / 2)
        let xWindth:CGFloat = CGFloat(x + y)
        button.center = CGPointMake(xWindth, CGFloat(self.view.frame.size.height-30))
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: .Normal)
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.tag = 1000+index.hashValue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        return button
    }
    
    //点击事件
    func loginClick() {
        
        self.transitionToNewStatus(currentStatus.loginStatus)
        
    }
    func signupClick() {
        
        self.transitionToNewStatus(currentStatus.signupStatus)
        
    }
    func confirmClick() {
        
        for subview in self.cardView.subviews {
            
            subview.resignFirstResponder()
            
        }
        self.transitionToNewStatus(currentStatus.freeStatus)
        
    }
    func cancelClick() {
        
        for subview in self.cardView.subviews {
            
            subview.resignFirstResponder()
            
        }
        self.transitionToNewStatus(currentStatus.freeStatus)
        
    }
    // 当前按钮状态发生改变时改变按钮标题和事件
    
    func transitionToNewStatus(newStatus:currentStatus) {
        
        var leftButtonTitles = [leftButtonFreeTitle, leftButtonLoginTItle, leftButtonSignUpTitle];
        var rightButtonTitles = [rightButtonFreeTitle, rightButtonLoginTitle, rightButtonSignupTitle];
        var leftButtonActions = [leftButtonFreeAction, leftButtonLoginAction, leftButtonSignupAction];
        var rightButtonActions = [rightButtonFreeAction, rightButtonLoginAction, rightButtonSignupAction];
        
        //移除按钮事件
        self.leftButton.removeTarget(self, action: NSSelectorFromString(leftButtonActions[self.status.hashValue]), forControlEvents: UIControlEvents.TouchUpInside)
        self.rightButton.removeTarget(self, action: NSSelectorFromString(rightButtonActions[self.status.hashValue]), forControlEvents: .TouchUpInside)
        self.status = newStatus
        
        //刷新按钮事件
        self.leftButton.addTarget(self, action: NSSelectorFromString(leftButtonActions[newStatus.hashValue]), forControlEvents: .TouchUpInside)
        self.leftButton.setTitle(leftButtonTitles[newStatus.hashValue], forState: .Normal)
        
        self.rightButton.addTarget(self, action: NSSelectorFromString(rightButtonActions[newStatus.hashValue]), forControlEvents: .TouchUpInside)
        self.rightButton.setTitle(rightButtonTitles[newStatus.hashValue], forState: .Normal)
        
        switch (self.status.hashValue) {
            
        case currentStatus.freeStatus.hashValue :
            hideCardView()
        case currentStatus.loginStatus.hashValue:
            showCardView()
        case currentStatus.signupStatus.hashValue:
            showCardView()
        default :
            print("haha", terminator: "")
            
        }
        
        
        
        
    }
    func addCardView() {
        
        self.cardView.center = CGPointMake(CGRectGetMidX(self.view.bounds), -CGRectGetMidY(self.cardView.bounds));
        self.view.addSubview(cardView)
    }
    func hideCardView () {
        
        self.cardView.userName?.text  = ""
        self.cardView.passWord?.text = ""
        UIView.animateWithDuration(0.5, animations: {
            
            self.cardView.center = CGPointMake(self.cardView.center.x, self.cardView.center.y-500)
            
        })
    }
    
    func showCardView() {
        self.cardView.userName?.text  = ""
        self.cardView.passWord?.text = ""
        UIView.animateWithDuration(0.5, animations: {
            
            self.cardView.center = CGPointMake(self.cardView.center.x, self.cardView.center.y+500)
            
        })
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


