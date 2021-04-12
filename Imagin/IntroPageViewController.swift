//
//  IntroPageViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 08.04.2021.
//

import UIKit

class IntroPageViewController: UIPageViewController {
    
    weak var introDelegate: IntroPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        dataSource = self
        delegate = self
        if let firstViewController = orderedViewControllers.first {
               setViewControllers([firstViewController],
                   direction: .forward,
                   animated: true,
                   completion: nil)
           }
        
        introDelegate?.introPageViewController(introPageViewController: self,
            didUpdatePageCount: orderedViewControllers.count)
        }
    
    private lazy var orderedViewControllers: [UIViewController] = {
        return [self.newIntroViewController(number: 1),
                self.newIntroViewController(number: 2),
                self.newIntroViewController(number: 3)]
    }()

    private func newIntroViewController(number: Int) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Intro\(number)")
    }
}

extension IntroPageViewController: UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController,
       viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
                
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
                
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
                
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
                
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
                
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
                
        guard orderedViewControllersCount > nextIndex else {
            return orderedViewControllers.last
        }
                
        return orderedViewControllers[nextIndex]
    }
    
}

extension IntroPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: firstViewController) {
            introDelegate?.introPageViewController(introPageViewController: self,
                                                   didUpdatePageIndex: index)
        }
    }
    
}

protocol IntroPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func introPageViewController(introPageViewController: IntroPageViewController,
        didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func introPageViewController(introPageViewController: IntroPageViewController,
        didUpdatePageIndex index: Int)
    
}
