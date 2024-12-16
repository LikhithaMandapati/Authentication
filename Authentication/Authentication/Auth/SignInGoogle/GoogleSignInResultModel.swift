//
//  GoogleSignInResultModel.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 9/25/24.
//

import Foundation

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}
