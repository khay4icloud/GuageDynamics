//
//  ViewController.swift
//  GuageDynamics
//
//  Created by SRI KALYAN GANJA on 9/17/17.
//  Copyright © 2017 SRI KALYAN GANJA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Properties
    
    lazy var center : CGPoint = {
        let center = CGPoint(x:self.view.frame.midX, y:self.view.frame.midY)
        return center
    }()
    
    lazy var arrowRect : UIView = {

        let arrowRect = UIView(frame: CGRect(x:self.view.frame.midX-130,
                                             y:self.view.frame.midY-2.5,
                                             width:150 ,height:5))
        arrowRect.backgroundColor = UIColor.black
        
        return arrowRect
    }()
    
    lazy var circleLayer : CAShapeLayer = {
       
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:self.view.frame.midX, y:self.view.frame.midY),
                                      radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(CGFloat.pi*2), clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        
        circleLayer.fillColor = UIColor.blue.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 3.0
        
        return circleLayer
    }()
    
    lazy var circleView : UIView = {
        
        // To create a circle 
        // Width and Height need to be equal
        // Corner radius should be (Width Or Height)/2
        
        let circleView = UIView(frame: CGRect(x:0.0, y:0.0, width:20, height:20))
        circleView.center = self.view.center
        circleView.layer.cornerRadius = circleView.frame.width/2
        circleView.backgroundColor = UIColor.blue
        circleView.clipsToBounds = true
        
        return circleView
    }()
    
    lazy var miniView : UIView = {
        let miniView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width-40, height:self.view.frame.height-40))
        miniView.center = self.view.center
        miniView.backgroundColor = UIColor.red
        
        return miniView
    }()
    
    lazy var pushButton : UIButton = {
       
        let pushButton = UIButton(frame: CGRect(x:self.view.frame.midX-40, y:self.view.frame.height-50, width:80, height:30))
        pushButton.backgroundColor = UIColor.green
        pushButton.setTitle("Push", for: .normal)
        pushButton.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        
        return pushButton
    }()
    
    private var animator : UIDynamicAnimator!
    private var pushBehavior : UIPushBehavior!
    private var collision : UICollisionBehavior!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        addAnimator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- UIDynamics
    
    func addAnimator() {
        
        animator = UIDynamicAnimator(referenceView:self.view)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [arrowRect])
        itemBehaviour.elasticity = 0.6
        itemBehaviour.allowsRotation = true
        
        animator.addBehavior(itemBehaviour)
        
        addPinAttachment(for: arrowRect, and: miniView, at: center)
        
    }
    
    func addPinAttachment(for view1:UIView, and view2:UIView, at anchorPoint:CGPoint) {
        let pinAttachment = UIAttachmentBehavior.pinAttachment(with: view1, attachedTo: view2, attachmentAnchor: anchorPoint)
        pinAttachment.frictionTorque = 0
        pinAttachment.attachmentRange = UIFloatRangeMake(0, 180)
        
        animator.addBehavior(pinAttachment)
    }
    
    func addPushBehavior() {
        let push = UIPushBehavior(items:[arrowRect], mode:.instantaneous)
        push.magnitude = 1
        push.angle = 0
        
        animator.addBehavior(push)
    }
    
    func addCollisionBehavior() {
        collision = UICollisionBehavior(items:[arrowRect, miniView])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        animator.addBehavior(collision)
    }
    
    //MARK:- UIActions
    
    func pushAction(sender: UIButton!) {
        let push = UIPushBehavior(items:[arrowRect], mode:.instantaneous)
        push.magnitude = 0.1
        push.angle = 90
        
        animator.addBehavior(push)
    }
    
    //MARK:- Helper Methods

    func addViews() {
        self.view.addSubview(miniView)
        self.view.addSubview(arrowRect)
        self.view.addSubview(pushButton)
        
    }
}

