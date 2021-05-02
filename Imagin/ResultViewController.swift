//
//  ResultController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 18.03.2021.
//

import UIKit

class ResultViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var photoFromUser: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorCircle: UIImageView!
    
    @IBOutlet weak var color1: UIImageView!
    @IBOutlet weak var color2: UIImageView!
    @IBOutlet weak var color3: UIImageView!
    var colors: [UIImageView] = [];
    var currentColor: Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppUtility.lockOrientation(.portrait)
        photoFromUser.image = user.photo
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        
        colors = [color1, color2, color3]
        //self.colors[0].transform = CGAffineTransform(scaleX: 88 / 72, y: 88 / 72)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapOnCircle(_ gestureRecognizer : UITapGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
               
          if gestureRecognizer.state == .ended {      // Move the view down and to the right when tapped.
             let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                gestureRecognizer.view!.center.x += 100
                gestureRecognizer.view!.center.y += 100
             })
             animator.startAnimation()
          }
        
    }
    @IBAction func tapOnColor(_ sender: UITapGestureRecognizer) {
        print("tap!!")
        let point = sender.location(ofTouch: 0, in: colorCircle)
        let x = point.x * CGFloat((colorCircle.image!.cgImage!.width)) / colorCircle.frame.size.width
        let y = point.y * CGFloat((colorCircle.image!.cgImage!.height)) / colorCircle.frame.size.height
        print("x: ", point.x, " y: ", point.y)
        print("image x: ", x, " y: ", y)
        print("image width: ", colorCircle.image?.cgImage?.width)
        print("uiimage width: ", colorCircle.frame.size.width)
        var color = colorCircle.image?.getPixelColor(pos: CGPoint(x: x, y: y))
        
        if (color != colorCircle.image?.getPixelColor(pos: CGPoint(x: 50, y: 50))) {
            colors[currentColor].backgroundColor = color
            let old = currentColor
            currentColor += 1
            if (currentColor == 3) {
                currentColor = 0
            }
            updateCurrentIndex(old: old, new: currentColor)
        }
    }
    func updateCurrentIndex(old: Int, new: Int) {
        UIView.animate(withDuration: 0.5) {
            self.colors[old].transform = CGAffineTransform(scaleX: 1, y: 1)
            self.colors[new].transform = CGAffineTransform(scaleX: 83 / 72, y: 83 / 72)
            self.scrollView.bringSubviewToFront(self.colors[new])
        }
    }
    @IBAction func tapColor1(_ sender: UITapGestureRecognizer) {
        updateCurrentIndex(old: currentColor, new: 0)
        currentColor = 0
    }
    @IBAction func tapColor2(_ sender: UITapGestureRecognizer) {
        updateCurrentIndex(old: currentColor, new: 1)
        currentColor = 1
    }
    
    @IBAction func tapColor3(_ sender: UITapGestureRecognizer) {
        updateCurrentIndex(old: currentColor, new: 2)
        currentColor = 2
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y
        )) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

}
