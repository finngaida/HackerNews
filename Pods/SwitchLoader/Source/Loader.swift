//
//  Loader.swift
//  Loader
//
//  Created by Lucas Ortis on 06/12/2015.
//  Copyright © 2015 Ekhoo. All rights reserved.
//

import UIKit

let kInset: CGFloat = 5.0

open class Loader: UIView {

    fileprivate var switchView: UIView?
    fileprivate var switchAnimationSide: Bool = false
    fileprivate var animationTimer: Timer?
    
    open var loaderColor: UIColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open var switchColor: UIColor {
        didSet {
            if let view = self.switchView {
                view.backgroundColor = self.switchColor
            }
        }
    }
    
    public override init(frame: CGRect) {
        self.loaderColor = UIColor.white
        self.switchColor = UIColor(red: 175.0 / 255.0, green: 85.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        
        super.init(frame: frame)
        
        self.switchView = UIView(frame: CGRect(x: kInset, y: kInset, width: frame.size.height - 2 * kInset, height: frame.size.height - 2 * kInset))
        self.switchView!.backgroundColor = self.switchColor
        self.switchView!.layer.cornerRadius = round(self.switchView!.frame.size.width / 2)
        self.switchView!.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.switchView!)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func animateSwitch() {
        if (self.frame.width > self.frame.height) {
            return;
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: { () -> Void in
            let frame: CGRect = self.bounds
            
            if self.switchView!.frame.origin.x > kInset {
                self.switchView!.frame = CGRect(x: kInset, y: /*self.switchView!.frame.origin.y*/ kInset, width: frame.width - 2 * kInset, height: self.switchView!.frame.height)
            } else {
                self.switchView!.frame = CGRect(x: self.switchView!.frame.origin.x, y: self.switchView!.frame.origin.y, width: frame.width - 2 * kInset, height: self.switchView!.frame.height)
            }
            
            self.switchView!.setNeedsDisplay()
        }) { (finished) -> Void in
            UIView.animate(withDuration: 0.30, animations: { () -> Void in
                let frame: CGRect = self.bounds

                if self.switchAnimationSide {
                    self.switchView!.frame = CGRect(x: kInset, y: /*self.switchView!.frame.origin.y*/ kInset, width: self.switchView!.frame.size.height, height: self.switchView!.frame.height)
                } else {
                    self.switchView!.frame = CGRect(x: frame.size.width - self.switchView!.frame.height - kInset, y: self.switchView!.frame.origin.y, width: self.switchView!.frame.size.height, height: self.switchView!.frame.height)
                }
                
                self.switchAnimationSide = !self.switchAnimationSide
                
                self.switchView!.setNeedsDisplay()
            })
        }
    }
    
    @objc fileprivate func animateLoader() {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.transform = self.transform.rotated(by: CGFloat.pi/2);
        }) 
        
        animateSwitch()
    }
    
    open func startAnimating() {
        self.animationTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(Loader.animateLoader), userInfo: nil, repeats: true)
    }
    
    open func stopAnimating() {
        if let timer = self.animationTimer {
            timer.invalidate()
            
            self.animationTimer = nil
        }
    }
    
    override open func draw(_ rect: CGRect) {
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: rect.size.width, height: rect.size.height), cornerRadius: round(rect.size.width / 2.0))
        self.loaderColor.setFill()
        rectanglePath.fill()
    }
    
}
