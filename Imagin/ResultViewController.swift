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
    override func viewDidLoad() {
        super.viewDidLoad()
        //photoFromtUser.image = user.photo
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
