//
//  PhotoController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 05.03.2021.
//

import UIKit

class PhotoController: UIViewController {
    /*func postIMage() {
        let json : [String: Any]
        let jsonData =
        let url = URL(string: "http://google.com") //ссылка на пост запрос на сервер
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
    }*/
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nextPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
            /*UIView.transition(with: photoFromUser, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.photoFromUser.isHidden = true
        }, completion: { _ in })*/
        UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.nextPage.isHidden = true
        }, completion: { _ in })
    }
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBAction func addPhoto(_ sender: Any) {
        print("photo!!")
        let alert = UIAlertController(title: "Photo", message: nil, preferredStyle: .actionSheet)
        let actionGallery = UIAlertAction(title: "From gallery", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "From camera", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(actionGallery)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var photoFromUser: UIImageView!
    
}
extension PhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // self.photo = pickedPhoto сделаю вьюшку image и кнопки типо повторить
            photoFromUser.image = pickedPhoto
            print("get photo!!")
            UIView.transition(with: photoFromUser, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.photoFromUser.isHidden = false
            }, completion: { _ in })
            addPhotoButton.setTitle("Another Photo", for: .normal)
            UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.nextPage.isHidden = false
            }, completion: { _ in })
        }
        dismiss(animated: true, completion: nil)
    }
    
}
