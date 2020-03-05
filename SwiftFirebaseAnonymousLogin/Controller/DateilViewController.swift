//
//  DateilViewController.swift
//  SwiftFirebaseAnonymousLogin
//
//  Created by 中野勇貴 on 2020/03/04.
//  Copyright © 2020 Nakano Yuki. All rights reserved.
//

import UIKit
import SDWebImage

class DateilViewController: UIViewController {

    var userName = String()
    var userImageString = String()
    var contentImageString = String()
    var comment = String()
    var createAt = String()
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    @IBOutlet weak var shearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shearButton.layer.cornerRadius = 20.0
        
        userNameLabel.text = userName
        userImageView.sd_setImage(with: URL(string: userImageString), completed: nil)
        contentImageView.sd_setImage(with: URL(string: contentImageString), completed: nil)
        commentLabel.text = comment
        createAtLabel.text = createAt
    }
    
    
    @IBAction func shearAction(_ sender: Any) {
        let item = [contentImageView.image] as [Any]
        let acView = UIActivityViewController(activityItems: item, applicationActivities: nil)
        
        present(acView, animated: true, completion: nil)
    }
    
    
    
   
}
