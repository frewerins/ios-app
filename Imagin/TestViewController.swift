//
//  TestViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 17.04.2021.
//

import UIKit

class TestViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descr: UITextView!
    var currentPage: Int = 0;
    var lastOffset: CGFloat = 0;
    var labels: [String] = ["What is it?", "How it works?", "What do you get?"];
    var descrs: [String] = ["Artificial Intelligence that will help you create a unique style",
    "Very cool!", "New life :)"];
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        scrollView.delegate = self
        scrollView.addSubview(introImage)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 609 / 375, height: UIScreen.main.bounds.height)
        
        NSLayoutConstraint(item: introImage!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: scrollView.contentSize.width / 2).isActive = true
        
       UIView.transition(with: startButton, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
            self.startButton.isHidden = true
        }, completion: { _ in })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x.truncatingRemainder(dividingBy: 5) == 0) {
            scrollView.contentOffset.x = CGFloat(scrollView.contentOffset.x - 2)
        }
       // if (abs(scrollView.contentOffset.x - lastOffset) > 20) {
            
            /*let width = Float(scrollView.contentSize.width)
            let screenWidth = Float(UIScreen.main.bounds.width)
            var target = 0
            if (scrollView.contentOffset.x > lastOffset) {
                currentPage = min(currentPage + 1, 2);
            } else {
                currentPage = max(currentPage - 1, 0);
            }
            self.pageControl.currentPage = currentPage
            if (currentPage == 1) {
                target = Int(width / 2 - screenWidth / 2)
            }
            if (currentPage == 2) {
                target = Int(width / 2 + screenWidth / 2)
                UIView.transition(with: label, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.startButton.isHidden = false
                }, completion: { _ in })
            }
            
            self.lastOffset = CGFloat(target)
        
            let bottomOffset = CGPoint(x: self.lastOffset + 50, y: 0)
            
            //scrollView.isScrollEnabled = false
            
            UIView.animate(withDuration: 5, animations: {
                scrollView.setContentOffset(bottomOffset, animated: true)
            })*/
            //scrollView.isScrollEnabled = true
       // }
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let width = Float(scrollView.contentSize.width)
        let screenWidth = Float(UIScreen.main.bounds.width)
        print(scrollView.contentOffset.x)
        if (abs(scrollView.contentOffset.x - lastOffset) < 10) {
            return
        }
        if (scrollView.contentOffset.x > lastOffset) {
            currentPage = min(currentPage + 1, 2);
        } else {
            currentPage = max(currentPage - 1, 0);
        }
        self.pageControl.currentPage = currentPage
        if (currentPage == 0) {
            targetContentOffset.pointee.x = 0
        }
        if (currentPage == 1) {
            targetContentOffset.pointee.x = CGFloat(width / 2 - screenWidth / 2)
        }
        if (currentPage == 2) {
            targetContentOffset.pointee.x = CGFloat(width / 2 + screenWidth / 2)
            UIView.transition(with: label, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                self.startButton.isHidden = false
            }, completion: { _ in })
        }
        
        self.lastOffset = targetContentOffset.pointee.x
        
        let bottomOffset = CGPoint(x: self.lastOffset, y: 0)
        
        UIView.animate(withDuration: 1, animations: {
            scrollView.setContentOffset(bottomOffset, animated: true)
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.label.alpha = 0
        })
        
        self.label.text = self.labels[self.currentPage]
        UIView.animate(withDuration: 1, animations: {
            self.label.alpha = 1
        })
        
        
        UIView.animate(withDuration: 1, animations: {
            self.descr.alpha = 0
        })
        
        self.descr.text = self.descrs[self.currentPage]
        UIView.animate(withDuration: 1, animations: {
            self.descr.alpha = 1
        })
        
       /*UIView.transition(with: label, duration: 0.6, options: .transitionCrossDissolve, animations: {() -> Void in
            self.label.text = self.labels[self.currentPage]
        }, completion: { _ in })*/
      }
}
