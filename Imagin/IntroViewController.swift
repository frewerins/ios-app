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
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        //self.setupScrollView()
        //self.scrollView.addSubview(itemView)
    }
    
    @IBOutlet weak var PageController: UIPageControl!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introImage: UIImageView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let introPageViewController = segue.destination as? IntroPageViewController {
                introPageViewController.introDelegate = self
            }
        }
    
    private func setupScrollView() {
        self.scrollView.decelerationRate = .fast
        self.scrollView.showsHorizontalScrollIndicator = false
    }
}

extension IntroViewController: IntroPageViewControllerDelegate {
    
    func update(introPageViewController: IntroPageViewController,
        didUpdatePageCount count: Int) {
        PageController.numberOfPages = count
    }
    
    func update(introPageViewController: IntroPageViewController,
        didUpdatePageIndex index: Int) {
        PageController.currentPage = index
    }
    
}
