//
//  SignInWithAppleButtonViewRepresentable.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/2/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: type, style: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}
