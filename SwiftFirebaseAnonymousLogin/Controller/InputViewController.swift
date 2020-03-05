//
//  InputViewController.swift
//  SwiftFirebaseAnonymousLogin
//
//  Created by 中野勇貴 on 2020/02/26.
//  Copyright © 2020 Nakano Yuki. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.layer.cornerRadius = 20.0
        userNameTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ナビゲーションバーを消す
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //他のところをタッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
    }
    //returnを押したらキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //決定ボタンを押したときの処理
    @IBAction func done(_ sender: Any) {
        
        //ユーザ名をアプリ内に保存
        UserDefaults.standard.set(userNameTextField.text, forKey: "userName")
        //ロゴをアプリ内に保存
            //dataを圧縮してセット
        let data = logoImageView.image?.jpegData(compressionQuality: 0.1)
        UserDefaults.standard.set(data, forKey: "userImage")
        //画面遷移
        let nextVC = self.storyboard?.instantiateViewController(identifier: "nextVC") as! NextViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //logoImageViewがタップされた時に
    @IBAction func imageViewTap(_ sender: Any) {
        //振動
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        //アラートを出す
        //カメラorアルバムを選択させる
        showAlert()
       
    }
    
    //カメラ立ち上げ
    func doCamera() {
        print("doCameraが呼ばれたよ")
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラが利用可能かチェックする
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    //アルバムの立ち上げ
    func doAlbum() {
        print("doAlbumが呼ばれたよ")
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //アルバムが利用可能かチェックする
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    //画像を選択した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] as! UIImage != nil {
            let selectedImage = info[.originalImage] as! UIImage
            UserDefaults.standard.set(selectedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            
            //logoImageViewへ選択した画像を反映
            logoImageView.image = selectedImage
            //pickerを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //pickerでキャンセルボタンを押した時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //アラート
    func showAlert() {
        let alert = UIAlertController(title: "選択", message: "どちらを選択しますか？", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        present(alert, animated: true, completion: nil)
    }
}
