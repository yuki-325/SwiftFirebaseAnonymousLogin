//
//  NextViewController.swift
//  SwiftFirebaseAnonymousLogin
//
//  Created by 中野勇貴 on 2020/02/27.
//  Copyright © 2020 Nakano Yuki. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import Photos

class NextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    var userName = String()
    var userImageData = Data()
    var userImage = UIImage()
    var commentString = String()
    var createAtString = String()
    var contentImageString = String()
    var userProfileImageString = String()
    var contentsArray = [Contents]()
    

    @IBOutlet weak var timeLineTableView: UITableView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    //選択された画像が入る変数
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カメラ使用許可
        PHPhotoLibrary.requestAuthorization { (status) in
            switch (status) {
            case .authorized:
                print("許可されています")
            case .denied:
                print("拒否されました")
            case .notDetermined:
                print("決まっていません")
            case .restricted:
                print("制限されています")
            }
        }
        
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        //Firebaseに保存された"userName","userImage"を取り出す
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            //userImageに代入するためにUIImage型に変換しなければならない
            userImage = UIImage(data: userImageData)!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //画面が表示されるたびに
        fetchContentsData()
    }
    
//tableView
    //tableViewの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //tableViewの中のcellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
       }
    
    //cellがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userName = contentsArray[indexPath.row].userNameString
        userProfileImageString = contentsArray[indexPath.row].profileImageString
        contentImageString = contentsArray[indexPath.row].contentImageString
        commentString = contentsArray[indexPath.row].commentString
        createAtString = contentsArray[indexPath.row].createAtString
        
        performSegue(withIdentifier: "dateil", sender: nil)
    }
    
    //値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateilVC = segue.destination as! DateilViewController
        
        dateilVC.userName = userName
        dateilVC.userImageString = userProfileImageString
        dateilVC.contentImageString = contentImageString
        dateilVC.comment = commentString
        dateilVC.createAt = createAtString
    }
    //cellの構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("imakoko")//test
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //コンテンツ
            //プロフィール画像
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: contentsArray[indexPath.row].profileImageString), completed: nil)
        profileImageView.layer.cornerRadius = 30.0 //角丸
            //ユーザ名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = contentsArray[indexPath.row].userNameString
            //投稿日時
        let createAtLabel = cell.viewWithTag(3) as! UILabel
        createAtLabel.text = contentsArray[indexPath.row].createAtString
            //投稿した画像
        let contentImageView = cell.viewWithTag(4) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: contentsArray[indexPath.row].contentImageString), completed: nil)
            //コメント
        let commentLabel = cell.viewWithTag(5) as! UILabel
        commentLabel.text = contentsArray[indexPath.row].commentString
        
        return cell
       }
    
    //cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 540
    }

//cameraを立ち上げる
    @IBAction func cameraAction(_ sender: Any) {
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
    
    //pickerで画像が選択 or 写真が撮影された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImage = info[.originalImage] as! UIImage
        
        let editPostVC = self.storyboard?.instantiateViewController(identifier: "editPostVC") as! EditAndPostViewController
        //EditAndPostViewControllerへ選択した画像を渡す
        editPostVC.selectedImage = selectedImage
        
        //最後に画面遷移して投稿画面に
        self.navigationController?.pushViewController(editPostVC, animated: true)
        
        //pickerを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    //pickerでキャンセルボタンが押下された時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchContentsData() {
        //timeLineの最新の１００件を取ってくる
        let ref = Database.database().reference().child("timeLine").queryLimited(toLast: 100).queryOrdered(byChild: "createAt").observe(.value) { (snapShot) in
            //一旦contentsArrayを空にする
            self.contentsArray.removeAll()
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    //ここには一個一個のデータが入った箱 key:value
                    if let contentsData = snap.value as? [String: Any] {
                        let userName = contentsData["userName"] as? String
                        let userImageString = contentsData["userImage"] as? String
                        let contentImageString = contentsData["contents"] as? String
                        //commentsのchildはまだない？？
                        let commentString = contentsData["comment"] as? String
                        //時間に変換しないとまだ使えない
                        let createAt = contentsData["createAt"] as? CLong
                        //変換したものを代入
                        let createAtString = self.convertTimeStamp(createAt: createAt!)
                        
                        //contentsArrayに情報を詰めていく
                        self.contentsArray.append(Contents(userNameString: userName!, profileImageString: userImageString!, contentImageString: contentImageString!, commentString: commentString!, createAtString: createAtString))
                    }
                }
                //timeLineTableViewをリロード
                self.timeLineTableView.reloadData()
                
                //timeLineで自動スクロール
                let indexPath = IndexPath(row: self.contentsArray.count - 1, section: 0)
                if self.contentsArray.count >= 2 {
                    self.timeLineTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    
    //CLong型でFriebaseから取ってきたcreateAtを時間で表示させるためにString型へ変換する
    func convertTimeStamp(createAt: CLong) -> String{
        
        let date = Date(timeIntervalSince1970: TimeInterval(createAt / 1000))
        let fomatter = DateFormatter()
        fomatter.dateStyle = .long
        fomatter.timeStyle = .medium
        
        //String型で返される
        return fomatter.string(from: date)
    }
}
