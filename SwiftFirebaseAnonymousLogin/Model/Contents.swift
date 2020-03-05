//
//  Contents.swift
//  SwiftFirebaseAnonymousLogin
//
//  Created by 中野勇貴 on 2020/02/29.
//  Copyright © 2020 Nakano Yuki. All rights reserved.
//

import Foundation

class Contents {
    var userNameString:String = ""
    var profileImageString:String = ""
    var contentImageString:String = ""
    var commentString:String = ""
    var createAtString:String = ""
    
    init(userNameString: String, profileImageString: String, contentImageString: String, commentString: String, createAtString: String) {
        self.userNameString = userNameString
        self.profileImageString = profileImageString
        self.contentImageString = contentImageString
        self.commentString = commentString
        self.createAtString = createAtString
    }
    
    
}
