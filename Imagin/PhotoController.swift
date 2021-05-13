//
//  PhotoController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 05.03.2021.
//

import UIKit
//import JWT

class User {
    var photo: UIImage!;
    var coloType: Int = 0;
    var responseStatusCode: Int = 200;
}

var user = User()

class PhotoController: UIViewController {
    //var photo: UIImage!
    let imagePicker = UIImagePickerController()
    var nextController = UIViewController()
    
    @IBOutlet weak var nextPage: UIButton!
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionDescr: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        AppUtility.lockOrientation(.portrait)
        
        imagePicker.delegate = self
            /*UIView.transition(with: photoFromUser, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.photoFromUser.isHidden = true
        }, completion: { _ in })*/
        UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.nextPage.isHidden = true
        }, completion: { _ in })
        self.nextController = storyboard!.instantiateViewController(identifier: "ResultViewController")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
       // activityView.startAnimating()
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
        activityView.startAnimating()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        let newTitle = NSAttributedString(string: "Uploading...", attributes: attributes)
        
        UIView.transition(with: nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            //let newTitle = self.nextPage.currentAttributedTitle
            //newTitle?.setValue("Uploading", forKey: "string")
                self.nextPage.setAttributedTitle(newTitle, for: .normal)
            self.nextPage.isEnabled = false
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
        let http: HTTPCommunication = HTTPCommunication() {
            [weak self] (data) -> Void in
                
            if data != nil {
                self?.activityView.stopAnimating()
                UIView.transition(with: self!.nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                  //  self?.nextPage.isHidden = false
                }, completion: { _ in })
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.gray
                ]
                
                let newTitle = NSAttributedString(string: "Upload", attributes: attributes)
                
                UIView.transition(with: self!.nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                    //let newTitle = self.nextPage.currentAttributedTitle
                    //newTitle?.setValue("Uploading", forKey: "string")
                    self!.nextPage.setAttributedTitle(newTitle, for: .normal)
                    self!.nextPage.isEnabled = true
                    self!.addPhotoButton.isHidden = false
                }, completion: { _ in })
                
                self!.navigationController!.pushViewController(self!.nextController, animated: true)
            } else {
                self?.activityView.stopAnimating()
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.red
                ]
                let newTitle = NSAttributedString(string: "Something's wrong. Please try again", attributes: attributes)
                
                UIView.transition(with: self!.nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                        self!.nextPage.setAttributedTitle(newTitle, for: .normal)
                }, completion: { _ in })
                UIView.transition(with: self!.addPhotoButton, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                    self!.addPhotoButton.isHidden = false
                }, completion: { _ in })
                
            }
        }
        let url: URL = URL(string: "https://imagin.neurotone.net/api/v1/image/process")!
       // let imageData = user.photo.pngData()
       // let imageBase64 = imageData?.base64EncodedString()
       // print(imageBase64)
     //   let data: [String: Any] = [
      //      "file": imageBase64
     //   ]
       // let requestFactory = RequestFactory()
        //let data = requestFactory.createRequest()
        
        http.postURL(url)
    }
}

extension PhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            user.photo = pickedPhoto
            photoFromUser.image = pickedPhoto
            photoFromUser.layer.borderWidth = 3.0
            photoFromUser.layer.borderColor = CGColor(red: 90.0/255.0, green: 200.0/255.0, blue: 251.0/255.0, alpha: 1.0)
            photoFromUser.layer.cornerRadius = 10
            
            print("get photo!!")
            UIView.transition(with: photoFromUser, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.photoFromUser.isHidden = false
            }, completion: { _ in })
            
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray
            ]
            
            let newTitle = NSAttributedString(string: "Upload", attributes: attributes)
            
            UIView.transition(with: self.nextPage, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.nextPage.setAttributedTitle(newTitle, for: .normal)
            }, completion: { _ in })
            self.nextPage.isEnabled = true
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

