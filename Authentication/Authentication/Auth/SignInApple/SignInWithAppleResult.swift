//
//  SignInWithAppleResult.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/1/24.
//

import Foundation

struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let name: String?
    let email: String?
}
