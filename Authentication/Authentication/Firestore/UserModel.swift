//
//  UserModel.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/15/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId : String
    let isAnonymous : Bool?
    let dateCreated : Date?
    let email : String?
    let photoUrl : String?
    let isPremium : Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "date_created"
        case email = "email"
        case photoUrl = "photo_url"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
    }
}
