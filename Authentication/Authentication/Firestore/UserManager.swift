//
//  UserManager.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class UserManager {
    static let shared = UserManager()
    private init() { }
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await userDocument(userId: userId).getDocument()
        guard let user = try snapshot.data(as: DBUser.self) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        return user
    }

    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.isPremium.rawValue : isPremium]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addPreference(userId: String, preference: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removePreference(userId: String, preference: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? Firestore.Encoder().encode(movie) else {
            throw URLError(.badURL)
        }
        let dict: [String : Any] = [DBUser.CodingKeys.favoriteMovie.rawValue : data]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeFavoriteMovie(userId: String) async throws {
        let data: [String : Any?] = [DBUser.CodingKeys.favoriteMovie.rawValue : nil]
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        let document = userFavoriteProductCollection(userId: userId).document()
        let data: [String: Any] = [
            "id" : document.documentID,
            "productId" : productId,
            "date_created" : Timestamp()
        ]
        try await document.setData(data, merge: false)
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
    
    func getAllUserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No docs")
                return
            }
            let products: [UserFavoriteProduct] = documents.compactMap({try? $0.data(as: UserFavoriteProduct.self)})
            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New products: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified products: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed products: \(diff.document.data())")
                }
            }
        }
    }
    
//    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
//        let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
//
//        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("No docs")
//                return
//            }
//            let products: [UserFavoriteProduct] = documents.compactMap({try? $0.data(as: UserFavoriteProduct.self)})
//            publisher.send(products)
//        }
//        return publisher.eraseToAnyPublisher()
//    }
    
    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId).addSnapshotListener(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductsListener = listener
        return publisher
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
}


struct UserFavoriteProduct: Codable {
    let id : String
    let productId : Int
    let date_created : Date
}
