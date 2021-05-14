//
//  ResultController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 18.03.2021.
//

import UIKit

// "seasonType" : [color1, color2, ...]
//var colorsFromServer: [String: [[UIColor]]] = ["winter" : nil, "summer" : nil, "autumn" : nil, "spring" : nil]

var colorsFromServer: [String: [[UIColor]]] = [:]

/*let colorsForLadder = [UIColor(red: 222/255, green: 19/255, blue: 84/255, alpha: 1),
    UIColor(red: 226/255, green: 106/255, blue: 71/255, alpha: 1),
    UIColor(red: 224/255, green: 78/255, blue: 20/255, alpha: 1),
    UIColor(red: 224/255, green: 116/255, blue: 67/255, alpha: 1)]*/

let seasons = ["Winter", "Autumn", "Summer", "Spring"]

var currentSeason: String = "winter";

var maxSizeForLadder = 0

class ResultViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var photoFromUser: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
   // @IBOutlet weak var colorCircle: UIImageView!
    
    @IBOutlet weak var collectinViewForColors: UICollectionView!
    
    @IBOutlet weak var collectionViewForSeasons: UICollectionView!
    @IBOutlet weak var seeAllButtonOutlet: UIButton!
    @IBOutlet weak var colorsTitle: UILabel!
    @IBOutlet weak var colorDescr: UILabel!
    @IBOutlet weak var seasonsTitle: UILabel!
    @IBOutlet weak var actionDescrBackground: UIImageView!
    //   @IBOutlet weak var color1: UIImageView!
  //  @IBOutlet weak var color2: UIImageView!
  //  @IBOutlet weak var color3: UIImageView!
    var colors: [UIImageView] = [];
    var currentColor: Int = 0;
    var seeAllwasTapped = false;
    let spacing = 10;
    var cellHeight: Float = 100;
    var cellWidth = 0;
    var wasTapOnCOlor = false;
    var ladder: Ladder!;
    
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!
   // @IBOutlet weak var seasonsTop: NSLayoutConstraint!
    @IBOutlet weak var seasonsTop: NSLayoutConstraint!
    @IBOutlet weak var actionDescrBackgroundTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait)
        photoFromUser.image = user.photo
       // scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        
//        colors = [color1, color2, color3]
        
        let http: HTTPCommunication = HTTPCommunication()
        
      //  print("colors from server ", colorsFromServer)
        http.getURL(URL(string: getUrl)!) {
            [weak self] (data) -> Void in
            let data = data as! DataFromServerGET
            for season in data.colors.keys {
                colorsFromServer[season] = []
                for i in 0...data.colors[season]!.count - 1 {
                    colorsFromServer[season]!.append([])
                    maxSizeForLadder = max(maxSizeForLadder, data.colors[season]![i].count)
                    for color in data.colors[season]![i] {
                        print("color ", color)
                        colorsFromServer[season]![i].append(UIColor(hexString: color))
                    }
                }
            }
            self!.showCollections()
        }
        
        
    }
    func showCollections() {
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
        
     //   actionDescrBackgroundTop.isActive = false
      //  actionDescrBackgroundTop = actionDescrBackground.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: CGFloat(-100))
       // actionDescrBackgroundTop.isActive = true
        
        ladder = Ladder(view: scrollView, maxSize: maxSizeForLadder)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        updateColorType(newSeason: currentSeason)
    }
    
    @IBAction func tapOnSeeAll(_ sender: Any) {
        print("tap see all")
        var offset: Float
        if (seeAllwasTapped) {
            seeAllwasTapped = false
            offset = cellHeight + 30
            //seeAllButtonOutlet.setImage(UIImage(contentsOfFile: "topPointer.png"), for: [])
        } else {
            seeAllwasTapped = true
            let linesCount =  Int((collectinViewForColors.visibleCells.count - 1) / 6) + 1
            let d = (linesCount - 1) * spacing
            offset = Float(Int(Float(linesCount) * cellHeight) + d + 30)
            //seeAllButtonOutlet.setImage(UIImage(contentsOfFile: "bottomPointer.png"), for: [])
        }
        collectionViewBottom.isActive = false
        collectionViewBottom = collectinViewForColors.bottomAnchor.constraint(equalTo: colorDescr.topAnchor, constant: CGFloat(offset))
        collectionViewBottom.isActive = true
    }
    
    func updateColorType(newSeason: String) {
        currentSeason = newSeason
        colorsTitle.text = currentSeason.uppercased()
        collectinViewForColors.reloadData()
        // отрисовка новых cell
    }
    
/*
    @IBAction func tapOnCircle(_ gestureRecognizer : UITapGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
               
          if gestureRecognizer.state == .ended {      // Move the view down and to the right when tapped.
             let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                gestureRecognizer.view!.center.x += 100
                gestureRecognizer.view!.center.y += 100
             })
             animator.startAnimation()
          }
        
    }*/
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
            print(colorsFromServer[currentSeason]!.count)
            return colorsFromServer[currentSeason]!.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "colors" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            cell.colorBackground.backgroundColor = colorsFromServer[currentSeason]![indexPath.item][0]
            cell.colorBackground.layer.cornerRadius = 10
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeasonCollectionViewCell", for: indexPath) as! SeasonCollectionViewCell
            cell.label.text = seasons[indexPath.item]
            for i in 0...cell.images.count - 1 {
                cell.images[i].backgroundColor = colorsFromServer[seasons[indexPath.item].lowercased()]?[i][0]
                cell.images[i].layer.cornerRadius = 5
                cell.stackView.addArrangedSubview(cell.images[i])
            }
            cell.seasonIndex = indexPath.item
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if collectionView.restorationIdentifier == "colors" {
            let colorsForLadder = colorsFromServer[currentSeason]![indexPath.item]
            if (!wasTapOnCOlor) {
                wasTapOnCOlor = true
                for cell in collectionView.visibleCells as! [ColorCollectionViewCell] {
                    if (collectionView.indexPath(for: cell) != indexPath) {
                        cell.colorBackground.alpha = 0.1
                    } else {
                        cell.colorBackground.alpha = 1
                    }
                }
                ladder.show(collectionView: collectionView, indexPath: indexPath, colors: colorsForLadder)
                if (ladder.images[ladder.visibleImagesCount - 1].frame.maxY > collectinViewForColors.frame.maxY) {
                seasonsTop.isActive = false
                seasonsTop = seasonsTitle.topAnchor.constraint(equalTo: ladder.images[ladder.visibleImagesCount - 1].bottomAnchor, constant: 30)
                    seasonsTop.isActive = true
                }
            } else {
                wasTapOnCOlor = false
                ladder.hide()
                for cell in collectionView.visibleCells as! [ColorCollectionViewCell] {
                        cell.colorBackground.alpha = 1
                }
                
                seasonsTop.isActive = false
                seasonsTop = seasonsTitle.topAnchor.constraint(equalTo: collectinViewForColors.bottomAnchor, constant: 30)
                seasonsTop.isActive = true
            }
            //seeAllButtonOutlet.sendActions(for: .touchUpInside)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! SeasonCollectionViewCell
            updateColorType(newSeason: (cell.label.text!.lowercased()))
        }
    }
    
}


class Ladder {
    var images: [UIImageView] = [];
    var visibleImagesCount = 0;
    init(view: UIView, maxSize: Int) {
        for i in 0...maxSize {
            let newImageView = UIImageView()
            newImageView.isHidden = true
            view.addSubview(newImageView)
            images.append(newImageView)
        }
    }
    
    func show(collectionView: UICollectionView, indexPath: IndexPath, colors: [UIColor]) {
        let colorsForLadder = colorsFromServer[currentSeason]![indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)!
        let height = cell.frame.height / 3
        let space = height * 2 / 3
        let offsetX = collectionView.frame.minX
        let offsetY = collectionView.frame.minY
        let index = indexPath.item % 6
        if index < 3 {
            let x = cell.frame.minX
            var y = cell.frame.minY - space
            for i in 0...colors.count - 1 {
                let maxX = collectionView.cellForItem(at: [0, min(index + i, 5)])!.frame.maxX
                let newImageView = images[i]
               // print("x ", x, "y ", y)
                newImageView.frame = CGRect(x: offsetX + x, y: offsetY + y + space, width: maxX - x, height: height)
                newImageView.layer.cornerRadius = 10
                newImageView.backgroundColor = colorsForLadder[i]
                //images.append(newImageView)
                y = y + space
            }
        } else {
            var y = cell.frame.minY - space
            let maxX = cell.frame.maxX
            for i in 0...colorsForLadder.count - 1 {
                let x = collectionView.cellForItem(at: [0, max(0, index - i)])!.frame.minX
                let newImageView = images[i]
                //print("x ", x, "y ", y)
                newImageView.frame = CGRect(x: offsetX + x, y: offsetY + y + space, width: maxX - x, height: height)
                newImageView.layer.cornerRadius = 10
                newImageView.backgroundColor = colorsForLadder[i]
               // images.append(newImageView)
                y = y + space
            }
        }
        for i in 0...colors.count - 1 {
            images[i].isHidden = false
        }
        visibleImagesCount = colors.count
    }
    
    func hide() {
        for image in images {
            image.isHidden = true
        }
        visibleImagesCount = 0
    }
}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
