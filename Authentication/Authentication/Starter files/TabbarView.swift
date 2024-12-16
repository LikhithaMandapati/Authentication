//
//  TabbarView.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/25/24.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationView {
                ProductsView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }
            
            NavigationView {
                FavoriteView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            
            NavigationView {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(showSignInView: .constant(false))
    }
}
