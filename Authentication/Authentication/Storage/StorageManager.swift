//
//  StorageManager.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 11/12/24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    private var imageReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    func saveImage(data: Data, completion: @escaping (String, String) -> Void) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        
        // Upload the data to Firebase Storage with a completion handler
        storage.child(path).putData(data, metadata: meta) { metadata, error in
            if let error = error {
                print("Error saving image: \(error.localizedDescription)")
                return
            }
            
            guard let metadata = metadata else {
                print("No metadata returned")
                return
            }
            
            // Return the path and name from the metadata
            let uploadedPath = metadata.path ?? "unknown"
            let uploadedName = metadata.name ?? "unknown"
            completion(uploadedPath, uploadedName)
        }
    }
}
