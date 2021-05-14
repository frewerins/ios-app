//
//  SplashController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 18.04.2021.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.isNavigationBarHidden = true
       // let nextController = storyboard!.instantiateViewController(identifier: "TestViewController")
        logoImage.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.logoImage.alpha = 1
        })
        UIView.animate(withDuration: 2.5) {
            self.progress.setProgress(1.0, animated: true)
        }
        let firstTime = UserDefaults.standard.object(forKey: "firstTimeOpened") as? Bool;
        let viewId: String
        if firstTime == nil {
            viewId = "TestViewController"
        } else {
            viewId = "PhotoController"
        }
        let nextController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewId)
        UserDefaults.standard.set(false, forKey: "firstTimeOpened")
        Timer.scheduledTimer(withTimeInterval: 2.6, repeats: false) { (_) in
            self.navigationController!.pushViewController(nextController, animated: true)
        }
    
    }

}

/*
protocol SplashPresenterDescription: class {
    func present()
    func dismiss(completion: @escaping () -> Void)
}

protocol SplashAnimatorDescription: class {
    func animateAppearance()
    func animateDisappearance(completion: @escaping () -> Void)
}

final class SplashPresenter: SplashPresenterDescription {
    
    private lazy var foregroundSplashWindow: UIWindow = {
            let splashViewController = self.splashViewController()
            let splashWindow = self.splashWindow(windowLevel: .normal + 1, rootViewController: splashViewController)
            
            return splashWindow
        }()

    private func splashWindow(windowLevel: UIWindow.Level, rootViewController: SplashViewController?) -> UIWindow {
        let splashWindow = UIWindow(frame: UIScreen.main.bounds)
        
        splashWindow.windowLevel = windowLevel
        splashWindow.rootViewController = rootViewController
        
        return splashWindow
    }
        
    private func splashViewController() -> SplashViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController")
            
        let splashViewController = viewController as? SplashViewController
            
        return splashViewController
    }
    
    private lazy var animator: SplashAnimatorDescription = SplashAnimator(foregroundSplashWindow: foregroundSplashWindow)
    
    func present() {
       animator.animateAppearance()
    }
    
    func dismiss(completion: @escaping () -> Void) {
        animator.animateDisappearance(completion: completion)
    }
}

final class SplashAnimator: SplashAnimatorDescription {
    
    private let foregroundSplashWindow: UIWindow
    private let foregroundSplashViewController: SplashViewController

    init(foregroundSplashWindow: UIWindow) {
        self.foregroundSplashWindow = foregroundSplashWindow

        guard let foregroundSplashViewController = foregroundSplashWindow.rootViewController as? SplashViewController else {
            fatalError("Splash window doesn't have splash root view controller!")
        }
        
        self.foregroundSplashViewController = foregroundSplashViewController
    }
    
    func animateAppearance() {
        print("animation start!!")
        self.foregroundSplashWindow.makeKeyAndVisible()
        foregroundSplashViewController.logoImage.alpha = 0
                
        UIView.animate(withDuration: 2, animations: {
        self.foregroundSplashViewController.logoImage.alpha = 1
            
        })
        
        UIView.animate(withDuration: 4.0) {
            self.foregroundSplashViewController.progress.setProgress(1.0, animated: true)
        }
        print("animation end!!")
    }
    
    func animateDisappearance(completion: @escaping () -> Void) {
    }
}*/
