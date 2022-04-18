//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Berke Baç on 13.04.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectimage))
        imageView.addGestureRecognizer(imageTapRecognizer)
        
        
    }
    
    @objc func selectimage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleinput: String, messageInput: String){
        let alert = UIAlertController(title: titleinput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func saveButton(_ sender: Any) {
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child("media")
            
            if let data = imageView.image?.jpegData(compressionQuality: 0.5){
                
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { (metadata, error) in
                    if error != nil {
                        self.makeAlert(titleinput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        
                    }else {
                        imageReference.downloadURL { (url, error) in
                            let imageurl = url?.absoluteString
                            print(imageurl)
                                
                              
    //                        Database
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageurl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.descriptionTextField.text!, "date" : FieldValue.serverTimestamp() , "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleinput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                }else{
                                    self.descriptionTextField.text = ""
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                            }
                        }
                    }
                }
            
            
            
            
            
            
        }
        
        
        
    }
    
    


