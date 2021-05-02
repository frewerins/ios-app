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
    var offsets: [Float] = [0, 0, 0];
    var wasAutomatedScroll: Bool = false;
    var labels: [String] = ["What is it?", "How it works?", "What do you get?"];
    var descrs: [String] = ["Artificial Intelligence that will help you create a unique style",
    "Very cool!", "New life :)"];
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        AppUtility.lockOrientation(.portrait)
        
        scrollView.delegate = self
        scrollView.addSubview(introImage)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 609 / 375, height: UIScreen.main.bounds.height)
        
        offsets[1] = Float(scrollView.contentSize.width) / 2 - Float(UIScreen.main.bounds.width) / 2
        offsets[2] = Float(scrollView.contentSize.width) - Float(UIScreen.main.bounds.width)
        
        NSLayoutConstraint(item: introImage!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: scrollView.contentSize.width / 2).isActive = true
        
       UIView.transition(with: startButton, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
            self.startButton.isHidden = true
        }, completion: { _ in })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentX = Float(scrollView.contentOffset.x)
        if (currentX < Float(lastOffset)) {
            if (currentX < offsets[max(currentPage - 1, 0)]) {
                print("auto scroll!!")
                scrollView.isScrollEnabled = false
                scrollView.setContentOffset(CGPoint(x: Int(offsets[max(currentPage - 1, 0)]), y: 0), animated: true)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                    scrollView.isScrollEnabled = true
                }
            }
        } else {
            if (currentX > offsets[min(currentPage + 1, 2)]) {
                print("auto scroll!!")
                scrollView.isScrollEnabled = false
                scrollView.setContentOffset(CGPoint(x: Int(offsets[min(currentPage + 1, 2)]), y: 0), animated: true)
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                    scrollView.isScrollEnabled = true
                }
            }
        }
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("endscrol!!")
       // let width = Float(scrollView.contentSize.width)
       // let screenWidth = Float(UIScreen.main.bounds.width)
        //print(scrollView.contentOffset.x)
        if (scrollView.contentOffset.x > lastOffset) {
            currentPage = min(currentPage + 1, 2);
        } else {
            currentPage = max(currentPage - 1, 0);
        }
        self.pageControl.currentPage = currentPage
        
        targetContentOffset.pointee.x = CGFloat(self.offsets[currentPage])
        
        if (currentPage == 2) {
            UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
                self.startButton.isHidden = false
            }, completion: { _ in })
        }
        
        self.lastOffset = CGFloat(offsets[currentPage])
        
        let bottomOffset = CGPoint(x: self.lastOffset, y: 0)
        
       /* UIView.animate(withDuration: 0.3, animations: {
            scrollView.setContentOffset(bottomOffset, animated: true)
        })*/
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
      }
}
