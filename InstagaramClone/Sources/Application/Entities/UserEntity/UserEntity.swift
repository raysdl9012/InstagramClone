//
//  UserEntity
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import Foundation

struct UserEntity: Identifiable, Codable {
    
    let id: String
    var name: String
    var lastName: String
    let email: String
    var description: String
    var profileImage: MultimediaEntity?
    var followers: [String]?
    let createdAt: Date
    
    init(id: String, name: String, lastName: String, email: String, description: String,
         profileImage: MultimediaEntity?, followers: [String]) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.email = email
        self.description = description
        self.profileImage = profileImage
        self.followers = followers
        self.createdAt = Date()
    }
    
    func getFullName() -> String {
        "\(name) \(lastName)"
    }
    
    func getFolowersCount() -> Int {
        followers?.count ?? 0
    }
}

extension UserEntity {
    public static var mock: UserEntity {
        .init(
            id: "", name: "Reinner",
            lastName: "Daza",
            email: "",
            description: "",
            profileImage: .init(id: UUID(),
                                url: "",
                                type: .image, aspectRatio: 1),
            followers: []
        )
    }
}



