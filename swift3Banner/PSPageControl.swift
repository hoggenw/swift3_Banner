//
//  PSPageControl.swift
//  千机团Swift
//
//  Created by 王留根 on 16/9/30.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit

class PSPageControl: UIPageControl {
    
    var midBool =  false
    
    override var currentPage: Int {
        set {
            super.currentPage = newValue
            //插入当前选中的自定义视图
            updateDots(newValue: newValue)
        }
        get {
            return super.currentPage
        }
        
    }
    
    func updateDots(newValue:Int) {
        if self.subviews.count != 0{
            if !midBool {
                for subView in self.subviews {
                    let activeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: subView.frame.size.width, height: subView.frame.size.width))
                    activeImageView.tag = 200
                    subView.addSubview(activeImageView)
                    
                }
                midBool = true
            }
        }
        for index in 0..<(self.subviews.count) {
            let subView = self.subviews[index]
            if newValue == index {
                let activeImageView = subView.viewWithTag(200) as? UIImageView
                activeImageView?.image = UIImage(named: "01-cir-w")
            }else{
                let activeImageView = subView.viewWithTag(200) as? UIImageView
                activeImageView?.image = UIImage(named: "01-cir-b")
            }
            
        }
    
        
    }
    
}
