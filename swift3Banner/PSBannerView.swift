//
//  PSBannerView.swift
//  千机团Swift
//
//  Created by 王留根 on 16/9/30.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit


class PSBannerView: UIView {

    var scrollView: UIScrollView?
    var currentPageIndex: Int?
    var animationTimer: Timer?
    var pageControl : PSPageControl?

    //block
    //var totalPageCout : (()->Int)?
    var contentViewAtIndex : ((_ pageIndex: Int)->UIImageView)?
    var tapActionBlock: ((_ pageIndex: Int)-> Void)?
    //private
    private var contentViews : [UIImageView] = []
    var animationInterval : TimeInterval?
    private var totalPages :  Int?
    deinit {
        scrollView?.delegate = nil
    }
    
    init(frame: CGRect ,_ duration: TimeInterval) {
        super.init(frame: frame)
        if duration > 0 {
            animationTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(animationTimerDidFire(timer:)), userInfo: nil, repeats: true)
        }
        animationInterval = duration
        self.clipsToBounds = true
        scrollView = UIScrollView(frame: self.bounds)
        scrollView?.scrollsToTop = true
        scrollView?.isPagingEnabled = true
        scrollView?.delegate = self
        
        scrollView?.contentOffset = CGPoint(x: MAIN_WIDTH, y: 0)
        scrollView?.contentSize = CGSize(width: 3 * MAIN_WIDTH, height: self.bounds.size.height)
        self.addSubview(scrollView!)
        pageControl = PSPageControl(frame: CGRect(x: 0, y: self.bounds.size.height-20, width: MAIN_WIDTH, height: 10))
        pageControl?.isUserInteractionEnabled = false
        pageControl?.midBool = false
        self.addSubview(pageControl!)
        
    }
    //MARK:设置总页数后，启动动画
    
    func setTotalPagesCount(totalPageCout: (()->Int)) {
        self.totalPages = totalPageCout()
        print("totalPages = \(self.totalPages)")
        
        self.pageControl?.numberOfPages = self.totalPages!
        pageControl?.backgroundColor = UIColor.clear
        pageControl?.isUserInteractionEnabled = true
        pageControl?.midBool = false
        self.currentPageIndex = 0
        if self.totalPages == 1 {
            scrollView?.contentSize = CGSize(width: MAIN_WIDTH, height: self.bounds.size.height)
            configureContentViews()
            self.pageControl?.isHidden = true
            
        }else{
            self.pageControl?.isHidden = false
        }
        if self.totalPages! > 0 && self.totalPages! != 1 {
            configureContentViews()
            self.animationTimer?.resumeTimerAfterInterval(self.animationInterval!)
        }
        
        
    }
    
    func configureContentViews() {
        for subView in (self.scrollView?.subviews)! {
            subView.removeFromSuperview()
        }
        setScrollViewDataSource()
        
        for index in 0..<self.contentViews.count {
            var contentView : UIImageView?
            if self.totalPages! < 3 {
                let midImageView = self.contentViews[index]
                let image = midImageView.image
                let newImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: MAIN_WIDTH, height: self.bounds.size.height))
                newImageView.contentMode = .redraw
                newImageView.image = image
                contentView = newImageView
            }else {
                contentView = self.contentViews[index]
                contentView?.frame = CGRect(x: 0, y: 0, width: MAIN_WIDTH, height: self.bounds.size.height)
            }
            
            contentView?.isUserInteractionEnabled = true
             var contenViewFrame = contentView?.frame
            contenViewFrame?.origin = CGPoint(x: CGFloat(MAIN_WIDTH) * CGFloat(index), y: 0)
            contentView?.frame = contenViewFrame!
            contentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentViewTapped(sender:))))
            self.scrollView?.addSubview(contentView!)
            
        }
        
        if self.totalPages != 1 {
            self.scrollView?.contentOffset = CGPoint(x: MAIN_WIDTH, y: 0)
        }else {
            self.scrollView?.contentOffset = CGPoint(x: MAIN_WIDTH * 2, y: 0)
        }
        
    }
    
    //点击事件 
    func contentViewTapped(sender: UIGestureRecognizer){
        if self.tapActionBlock != nil {
            self.tapActionBlock!(self.currentPageIndex!)
        }
        
    }
    //获取数据
    func setScrollViewDataSource () {
        let previousIndex = validateNextPageIndexWithPageIndex(index: self.currentPageIndex! - 1)
        let rearIndex = validateNextPageIndexWithPageIndex(index: self.currentPageIndex! + 1)
 
        self.contentViews.removeAll()
        
        if self.contentViewAtIndex != nil {
            self.contentViews.append(self.contentViewAtIndex!(previousIndex))
            self.contentViews.append(self.contentViewAtIndex!(currentPageIndex!))
            self.contentViews.append(self.contentViewAtIndex!(rearIndex))
            
        }
        
    }
    //获取下标
    func validateNextPageIndexWithPageIndex(index: Int) -> Int {
        
        if index < 0 {
            return self.totalPages! - 1;
        }else if index >= self.totalPages!{
            return 0
        }
        return index
        
    }
    
    func animationTimerDidFire(timer:Timer){
        let index = Int((self.scrollView?.contentOffset.x)!/MAIN_WIDTH)
        self.scrollView?.setContentOffset(CGPoint(x: MAIN_WIDTH * CGFloat(index)+MAIN_WIDTH, y: 0),animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PSBannerView:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.animationTimer?.pauseTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.animationTimer?.resumeTimerAfterInterval(self.animationInterval!)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (MAIN_WIDTH * CGFloat(2)) {
            self.currentPageIndex = validateNextPageIndexWithPageIndex(index:  self.currentPageIndex!+1)
            configureContentViews()
        }else if scrollView.contentOffset.x <= 0 {
            self.currentPageIndex = validateNextPageIndexWithPageIndex(index:  self.currentPageIndex!-1)
            configureContentViews()
        }
        
        self.pageControl?.currentPage = self.currentPageIndex!
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: MAIN_WIDTH, y: 0), animated: true)
    }
    
    
}

