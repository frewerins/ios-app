//
//  SeasonCollectionViewCell.swift
//  Imagin
//
//  Created by a.d.knyazeva on 12.05.2021.
//

import UIKit

let colorss = [UIColor(red: 222/255, green: 19/255, blue: 84/255, alpha: 1),
    UIColor(red: 226/255, green: 106/255, blue: 71/255, alpha: 1),
    UIColor(red: 224/255, green: 78/255, blue: 20/255, alpha: 1)]

class SeasonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    let images = [UIImageView(), UIImageView(), UIImageView(), UIImageView()];
}
