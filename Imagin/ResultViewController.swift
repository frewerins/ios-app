//
//  ResultController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 18.03.2021.
//

import UIKit

//заглушка на ответ от сервера
let colorsFromServer = [UIColor(red: 226/255, green: 79/255, blue: 28/255, alpha: 1), UIColor(red: 73/255, green: 11/255, blue: 160/255, alpha: 1),UIColor(red: 176/255, green: 191/255, blue: 120/255, alpha: 1),UIColor(red: 176/255, green: 191/255, blue: 120/255, alpha: 1),UIColor(red: 176/255, green: 191/255, blue: 120/255, alpha: 1),UIColor(red: 176/255, green: 191/255, blue: 120/255, alpha: 1),UIColor(red: 176/255, green: 191/255, blue: 120/255, alpha: 1),UIColor(red: 176/255, green: 191/255, blue: 120/255, alpha: 1)]

let seasons = ["Winter", "Autumn", "Summer", "Spring"]

class ResultViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var photoFromUser: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorCircle: UIImageView!
    
    @IBOutlet weak var collectinViewForColors: UICollectionView!
    
    @IBOutlet weak var collectionViewForSeasons: UICollectionView!
    @IBOutlet weak var colorsTitle: UILabel!
    @IBOutlet weak var colorDescr: UILabel!
    @IBOutlet weak var color1: UIImageView!
    @IBOutlet weak var color2: UIImageView!
    @IBOutlet weak var color3: UIImageView!
    var colors: [UIImageView] = [];
    var currentColor: Int = 0;
    var seeAllwasTapped = false;
    let spacing = 10;
    var cellHeight: Float = 100;
    var cellWidth = 0;
    
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppUtility.lockOrientation(.portrait)
        photoFromUser.image = user.photo
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        
        colors = [color1, color2, color3]
        collectinViewForColors.dataSource = self
        collectinViewForColors.delegate = self
        collectionViewForSeasons.dataSource = self
        collectionViewForSeasons.delegate = self
        
        
        cellWidth = (Int(Float(collectinViewForColors.frame.width)) - self.spacing * 5) / 6
        cellHeight = Float(Double(cellWidth) * 2.5)
        
        let offset = cellHeight + 30
        collectionViewBottom.isActive = false
        collectionViewBottom = collectinViewForColors.bottomAnchor.constraint(equalTo: colorDescr.topAnchor, constant: CGFloat(offset))
        collectionViewBottom.isActive = true
    }
    
    @IBAction func tapOnSeeAll(_ sender: Any) {
        var offset: Float
        if (seeAllwasTapped) {
            seeAllwasTapped = false
            offset = cellHeight + 30
            
        } else {
            seeAllwasTapped = true
            let linesCount =  Int((colorsFromServer.count - 1) / 6) + 1
            let d = (linesCount - 1) * spacing
            offset = Float(Int(Float(linesCount) * cellHeight) + d + 30)
            
        }
        collectionViewBottom.isActive = false
        collectionViewBottom = collectinViewForColors.bottomAnchor.constraint(equalTo: colorDescr.topAnchor, constant: CGFloat(offset))
        collectionViewBottom.isActive = true
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
    /*
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
            /*currentColor += 1
            if (currentColor == 3) {
                currentColor = 0
            }
            updateCurrentIndex(old: old, new: currentColor)*/
        }
    }
    func updateCurrentIndex(old: Int, new: Int) {
        UIView.animate(withDuration: 0.1) {
            self.colors[old].transform = CGAffineTransform(scaleX: 1, y: 1)
            self.colors[old].layer.borderWidth = 0
            
            self.colors[new].transform = CGAffineTransform(scaleX: 80 / 72, y: 80 / 72)
            self.colors[new].layer.borderColor = CGColor(red: 249.0/255.0, green: 219.0/255.0, blue: 109.0/255.0, alpha: 1)
            self.colors[new].layer.borderWidth = 4
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
    }*/
    
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

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("id ", collectionView.restorationIdentifier)
        if collectionView.restorationIdentifier == "colors" {
            return colorsFromServer.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "colors" {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorBackground.backgroundColor = colorsFromServer[indexPath.item]
        cell.colorBackground.layer.cornerRadius = 10
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeasonCollectionViewCell", for: indexPath) as! SeasonCollectionViewCell
            cell.label.text = seasons[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.restorationIdentifier == "colors" {
            let cellWidth = (Int(Float(collectionView.frame.width)) - self.spacing * 5) / 6
        //self.cellHeight = Float(Double(cellWidth) * 2.5)
            return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        } else {
            return CGSize(width: collectionView.frame.width * 2/5, height: collectionView.frame.height)
        }
    }
    
}
