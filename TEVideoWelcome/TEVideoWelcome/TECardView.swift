//
//  TECardView.swift
//  TEVideoWelcome
//
//  Created by offcn on 15/9/6.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

import UIKit

class CardView: UIView {
    var userName:UITextField?
    var passWord:UITextField?
    var judge:Bool?
    init() {
        let viewFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height*2/3)
        super.init(frame: viewFrame)
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        for index in 0...1{
            let filed = UITextField(frame: CGRectMake(0, 0, 220, 30))
            filed.borderStyle = UITextBorderStyle.RoundedRect
            filed.center = CGPointMake(self.frame.size.width/2, CGFloat(200+index*50))
            if index==0 {
                judge = true
                
            }else{
                judge = false
            }
            filed.placeholder = judge! ? "passWord":"userName"
            filed.secureTextEntry = judge!
            filed.keyboardAppearance = UIKeyboardAppearance.Dark
            if(!judge!) {
                
                self.userName = filed
            }else {
                
                self.passWord = filed
            }
            self.addSubview(filed)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for  subview in self.subviews {
            subview.resignFirstResponder()
            
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    
}

