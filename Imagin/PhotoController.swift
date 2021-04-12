//
//  PhotoController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 05.03.2021.
//

import UIKit

class PhotoController: UIViewController {
    var photo: UIImage!
    let imagePicker = UIImagePickerController()
    var nextController = UIViewController()
    
    @IBOutlet weak var nextPage: UIButton!
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionDescr: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
            /*UIView.transition(with: photoFromUser, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.photoFromUser.isHidden = true
        }, completion: { _ in })*/
        UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.nextPage.isHidden = true
        }, completion: { _ in })
        self.nextController = storyboard!.instantiateViewController(identifier: "ResultViewController")
    }
    @IBAction func sendPhotoAction(_ sender: Any) {
        sendPhoto()
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
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
        return activityView
    }()
    
    func beforeSeinding() {
        UIView.transition(with: addPhotoButton, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.addPhotoButton.isHidden = true
        }, completion: { _ in })
        
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityView.centerXAnchor.constraint(equalTo: self.addPhotoButton.centerXAnchor),
            self.activityView.centerYAnchor.constraint(equalTo:
                    self.addPhotoButton.centerYAnchor)
        ])
        UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray
            ]
            let newTitle = NSAttributedString(string: "Uploading...", attributes: attributes)
            //let newTitle = self.nextPage.currentAttributedTitle
            //newTitle?.setValue("Uploading", forKey: "string")
                self.nextPage.setAttributedTitle(newTitle, for: .normal)
        }, completion: { _ in })
        
        UIView.transition(with: actionLabel, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.actionLabel.text = "Photo processing"
        }, completion: { _ in })
        UIView.transition(with: actionDescr, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.actionDescr.text = "Calculate your color type and select clothes"
        }, completion: { _ in })
    }
    
    func sendPhoto() {
        beforeSeinding()
        let http: HTTPCommunication = HTTPCommunication()
        let url: URL = URL(string: "http://89.223.93.173:5000/process")!
        let imageData = photo.pngData()
        let imageBase64 = imageData?.base64EncodedString()
       // print(imageBase64)
        let data: [String: Any] = [
            "image": imageBase64,
                "metadata": [
                    "device": "ios"
                ]
        ]
        
        http.postURL(url, data: data) {
            [weak self] (data) -> Void in
                
            guard let json = String(data: data, encoding: String.Encoding.utf8) else { print("Invalid json")
                return
            }
            //print("JSON from server: ", json)
                    
            do {
               /* let jsonObjectAny: Any = try JSONSerialization.jsonObject(with: data, options: [])
                    
                guard
                    let jsonObject = jsonObjectAny as? [String: Any],
                    let value = jsonObject["value"] as? [String: Any],
                    //let id = value["id"] as? Int,
                    let joke = value["joke"] as? String else {
                        return
                    }*/
                //self?.nextPage.setTitle(joke, for: .normal)
                self?.activityView.stopAnimating()
                UIView.transition(with: self!.nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                    self?.nextPage.isHidden = false
                }, completion: { _ in })
                self!.navigationController!.pushViewController(self!.nextController, animated: true)
            } catch {
                print("Can't serialize data.")
            }
        }
    }
}

extension PhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo = pickedPhoto
            photoFromUser.image = pickedPhoto
            photoFromUser.layer.borderWidth = 3.0
            photoFromUser.layer.borderColor = CGColor(red: 90.0/255.0, green: 200.0/255.0, blue: 251.0/255.0, alpha: 1.0)
            photoFromUser.layer.cornerRadius = 10
            
            print("get photo!!")
            UIView.transition(with: photoFromUser, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.photoFromUser.isHidden = false
            }, completion: { _ in })
            UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.nextPage.isHidden = false
            }, completion: { _ in })
            UIView.transition(with: addPhotoButton, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.addPhotoButton.setTitle("Another Photo", for: .normal)
            }, completion: { _ in })
        }
        dismiss(animated: true, completion: nil)
    }
    
}
