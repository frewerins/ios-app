//
//  IntroViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 10.04.2021.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBOutlet weak var PageController: UIPageControl!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let introPageViewController = segue.destination as? IntroPageViewController {
                introPageViewController.introDelegate = self
            }
        }
}

extension IntroViewController: IntroPageViewControllerDelegate {
    
    func introPageViewController(introPageViewController: IntroPageViewController,
        didUpdatePageCount count: Int) {
        PageController.numberOfPages = count
    }
    
    func introPageViewController(introPageViewController: IntroPageViewController,
        didUpdatePageIndex index: Int) {
        PageController.currentPage = index
    }
    
}
