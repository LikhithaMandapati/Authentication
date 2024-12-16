//
//  RootView.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 9/17/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if showSignInView {
                AuthenticationView(showSignInView: $showSignInView)
            } else {
                //TabbarView(showSignInView: $showSignInView)
                //CrashView()
                AnalyticsView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
            
            try? AuthenticationManager.shared.getProviders()
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RootView()
        }
    }
}
