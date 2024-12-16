//
//  ProfileView.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/7/24.
//

import SwiftUI
import Foundation
import PhotosUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var showImagePicker = false
    @State private var selectedItem: UIImage?
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is Premuim: \((user.isPremium ?? false).description.capitalized)")
                }
                
                VStack {
                    HStack{
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(string) {
                                if preferenceSelected(text: string) {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceSelected(text: string) ? .green : .red)
                        }
                    }
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                } label: {
                    Text("Favorite Movie: \((user.favoriteMovie?.title ?? ""))")
                }
                
                Button("Select a photo") {
                    showImagePicker.toggle()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedItem: $selectedItem)
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onChange(of: selectedItem, perform: { newValue in
            if let newValue = newValue {
                // Convert the selected UIImage to Data (JPEG format)
                if let imageData = newValue.jpegData(compressionQuality: 0.8) {
                    // Pass imageData to saveProfileImage
                    viewModel.saveProfileImage(data: imageData)
                } else {
                    print("Error converting image to data")
                }
            }
        })
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink{
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RootView()
        }
    }
}
