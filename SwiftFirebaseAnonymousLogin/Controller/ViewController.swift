//
//  ViewController.swift
//  SwiftFirebaseAnonymousLogin
//
//  Created by 中野勇貴 on 2020/02/26.
//  Copyright © 2020 Nakano Yuki. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


    
    @IBAction func login(_ sender: Any) {
        //print("imakoko")
        //匿名ログイン
        Auth.auth().signInAnonymously { (authResult, error) in

            guard let user = authResult?.user else{return}
            print("匿名ログインが成功しました")
            print(user)

            //画面遷移
            let inputVC = self.storyboard?.instantiateViewController(identifier: "inputVC") as! InputViewController

        self.navigationController?.pushViewController(inputVC, animated: true)
        }
    }
}
