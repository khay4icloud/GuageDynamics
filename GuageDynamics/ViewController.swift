//
//  ViewController.swift
//  GuageDynamics
//
//  Created by SRI KALYAN GANJA on 9/17/17.
//  Copyright © 2017 SRI KALYAN GANJA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    //MARK:- Properties
    
    lazy var center : CGPoint = {
        let center = CGPoint(x:self.view.frame.midX, y:self.view.frame.midY)
        return center
    }()
    
    lazy var arrowRect : UIView = {

        let arrowRect = UIImageView(frame: CGRect(x:self.view.frame.midX-150,
                                             y:self.view.frame.midY-15,
                                             width:150 ,height:30))
        arrowRect.image = #imageLiteral(resourceName: "arrow.png")
        
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
    
    lazy var miniView : UIView = {
        let miniView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width-40, height:self.view.frame.height-400))
        miniView.center = self.view.center
        miniView.backgroundColor = UIColor.gray
        
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
        setAnchorPoint(anchorPoint: CGPoint(x:1.0, y:0.5), view: arrowRect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- UIDynamics
    
    
    //MARK:- UIActions
    
    func pushAction(sender: UIButton!) {
        arrowRect.rotate360Degrees(duration: 2.0, completionDelegate: self)
    }
    
    //MARK:- Helper Methods

    func addViews() {
        self.view.addSubview(arrowRect)
        self.view.addSubview(pushButton)
        self.view.layer.addSublayer(circleLayer)
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPoint(x:view.bounds.size.width * anchorPoint.x, y:view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x:view.bounds.size.width * view.layer.anchorPoint.x, y:view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    
    //MARK:- CAAnimation & Delegate
    
    func animationDidStart(_ anim: CAAnimation) {
        print("Animation did start")
        
        print("ArrowRect Specs: \(arrowRect.frame)")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Animation did stop")
        
        arrowRect.transform = arrowRect.transform.rotated(by: CGFloat(.pi * 1.0))
        arrowRect.frame = CGRect(x:self.view.frame.midX-150, y:self.view.frame.midY-15, width:arrowRect.frame.width, height:arrowRect.frame.height)
        
        print("ArrowRect Specs: \(arrowRect.frame)")
    }
    
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(CGFloat.pi * 0.5)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = (delegate as! CAAnimationDelegate)
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
