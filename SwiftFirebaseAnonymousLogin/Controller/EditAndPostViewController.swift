//
//  EditAndPostViewController.swift
//  SwiftFirebaseAnonymousLogin
//
//  Created by 中野勇貴 on 2020/03/01.
//  Copyright © 2020 Nakano Yuki. All rights reserved.
//

import UIKit
import Firebase

class EditAndPostViewController: UIViewController, UITextFieldDelegate{
    
    //投稿時に選択した画像を受け取る
    var selectedImage = UIImage()
    
    var userName = String()
    var userImage = UIImage()
    var userImageString = String()
    var userImageData = Data()
    
    //画面部品
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    //@IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navbarを消す
        //前の画面は継承されていないため記述が必要
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //keyboard
        setUpNotificationForTextField()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
       //アプリ内に保存されているデータを取り出して画面のパーツに反映していく
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            
            userImage = UIImage(data: userImageData)!
        }
        
        userNameLabel.text = userName
        userProfileImageView.image = userImage
        selectedImageView.image = selectedImage
        
    }
    

    @IBAction func postAction(_ sender: Any) {
        //DBのchildを決めていく
        
        let timeLineDB = Database.database().reference().child("timeLine").childByAutoId()
         
        let storage = Storage.storage().reference(forURL: "gs://swiftfirebaseanonymouslogin.appspot.com")
        
        let key = timeLineDB.child("users").childByAutoId().key
        let key2 = timeLineDB.child("contents").childByAutoId().key
        
        let imageRef = storage.child("users").child("\(String(describing: key!)).jpg")
        let imageRef2 = storage.child("contents").child("\(String(describing: key2!)).jpg")
        
        var userProfileImageData = Data()
        var contentImageData = Data()
   
        //print("imakoko")
        
        if userProfileImageView.image != nil {
            userProfileImageData = (userProfileImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        if selectedImageView.image != nil {
            contentImageData = (selectedImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        let uploadTask = imageRef.putData(userProfileImageData, metadata: nil) { (metaData, error) in
            if error != nil {
                print(error)
                return
            }
            //contentImageDataの処理が行われたらuserProfileDataの処理を行う
            let uploadTask2 = imageRef2.putData(contentImageData, metadata: nil) { (metaData, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                imageRef.downloadURL { (userImageUrl, error) in
                    if error != nil {
                        print(error)
                        return
                    } else {
                        imageRef2.downloadURL { (contentImageUrl, error) in
                            if error != nil {
                                print(error)
                                return
                            } else {
                                //キーバリュー型で送信するものを準備する
                                let timeLineInfo = [
                                    "userName": self.userName,
                                    "userImage": userImageUrl?.absoluteString,
                                    "contents": contentImageUrl?.absoluteString,
                                    "comment" : self.commentTextField.text,
                                    "createAt": ServerValue.timestamp()
                                    ] as [String : Any]
                                
                                timeLineDB.updateChildValues(timeLineInfo)
                                
                                
                            }
                        }
                    }
                }
            }
        }
        uploadTask.resume()
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }

    //他のところをタッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentTextField.resignFirstResponder()
    }
    //returnを押したらキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //キーボードが出てきたらテキストフィールドど送信ボタンを上げる
    func setUpNotificationForTextField() {
        let notificationCenter = NotificationCenter.default
        //キーボードが出る時に呼ばれる
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //キーボードが隠れる時に呼ばれる
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //キーボードが出ててきたらテキストフィールドと送信ボタンを元の位置へ戻す
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo //ここにキーボードの情報が入ってくる
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardSize.height //全体の高さ - キーボードの高さ
        let editingTextFieldY: CGFloat = (self.commentTextField?.frame.origin.y)!
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    //キーボードが隠れるときはテキストフィールドと送信ボタンを元の位置に戻す
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
}
