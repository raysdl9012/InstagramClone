//
//  FIRDatabaseService.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - Enum para errores de la base de datos
enum DatabaseError: LocalizedError {
    case documentNotFound
    case dataEncodingFailed
    case unknown(String)
    var errorDescription: String? {
        switch self {
        case .documentNotFound:
            return "No se encontró el documento del usuario."
        case .dataEncodingFailed:
            return "No se pudieron guardar los datos del usuario."
        case .unknown(let message):
            return "Error en la base de datos: \(message)"
        }
    }
}

// MARK: - Protocolo del Servicio de Base de Datos
protocol FIRDatabaseServiceProtocol {
    func createUser(_ user: UserEntity) throws
    func fetchUser(id: String) async throws -> UserEntity
    func createPost(_ post: PostEntity) async throws
    func createReel(_ reel: ReelEntity) async throws
    func fetchAllReels() async throws -> [ReelEntity]
    func fetchPosts(limit: Int, startAfter: DocumentSnapshot?) async throws -> ([PostEntity], DocumentSnapshot?)
    func fetchReels(limit: Int, startAfter: DocumentSnapshot?) async throws -> ([ReelEntity], DocumentSnapshot?)
    func fetchPosts(forUserID userID: String) async throws -> [PostEntity]
    func updatePost(_ post: PostEntity) async throws
    func updateReel(_ reel: ReelEntity) async throws
    func updateUser(_ user: UserEntity) async throws
    func addComment(_ comment: CommentEntity) async throws
    func fetchComments(forPostID postID: String) async throws -> [CommentEntity]
}

// MARK: - Implementación del Servicio de Firestore
class FIRDatabaseService: FIRDatabaseServiceProtocol {
    
    static let shared = FIRDatabaseService()
    private let db = Firestore.firestore()
    
    private init() {}
    
}

//MARK: USER
extension FIRDatabaseService {
    func createUser(_ user: UserEntity) throws {
        do {
            try db.collection(FIR_COLLECTION_USERS).document(user.id).setData(from: user)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func fetchUser(id: String) async throws -> UserEntity {
        do {
            let docRef = db.collection("users").document(id)
            let document = try await docRef.getDocument()
            guard let user = try? document.data(as: UserEntity.self) else {
                throw DatabaseError.documentNotFound
            }
            return user
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func updateUser(_ user: UserEntity) async throws {
        do {
            try db.collection(FIR_COLLECTION_USERS).document(user.id).setData(from: user, merge: true)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
}



//MARK: POST
extension FIRDatabaseService {
    // Añade esta nueva función dentro de la clase DatabaseService
    func createPost(_ post: PostEntity) async throws {
        do {
            try db.collection(FIR_COLLECTION_POSTS).document(post.id.uuidString).setData(from: post)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func fetchAllPosts() async throws -> [PostEntity] {
        do {
            let querySnapshot = try await db.collection("posts")
                .order(by: "timestamp", descending: true)
                .getDocuments()
            let posts = try querySnapshot.documents.compactMap { document in
                try document.data(as: PostEntity.self)
            }
            return posts
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func fetchPosts(limit: Int = 10, startAfter: DocumentSnapshot? = nil) async throws -> ([PostEntity], DocumentSnapshot?) {
        do {
            var query: Query = db.collection("posts")
                .order(by: "timestamp", descending: true)
                .limit(to: limit)
            if let lastDocument = startAfter {
                query = query.start(afterDocument: lastDocument)
            }
            let querySnapshot = try await query.getDocuments()
            let posts = try querySnapshot.documents.compactMap { document in
                try document.data(as: PostEntity.self)
            }
            return (posts, querySnapshot.documents.last)
            
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func fetchPosts(forUserID userID: String) async throws -> [PostEntity] {
        do {
            let querySnapshot = try await db.collection(FIR_COLLECTION_POSTS)
                .whereField("ownerId", isEqualTo: userID) // <-- El filtro clave
                .order(by: "timestamp", descending: true)
                .getDocuments()
            
            let posts = try querySnapshot.documents.compactMap { document in
                try document.data(as: PostEntity.self)
            }
            return posts
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func updatePost(_ post: PostEntity) async throws {
        do {
            try db.collection(FIR_COLLECTION_POSTS).document(post.id.uuidString).setData(from: post)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
}

extension FIRDatabaseService {
    func createReel(_ reel: ReelEntity) async throws {
        do {
            try db.collection(FIR_COLLECTION_REELS).document(reel.id.uuidString).setData(from: reel)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func fetchAllReels() async throws -> [ReelEntity] {
        do {
            let querySnapshot = try await db.collection(FIR_COLLECTION_REELS)
                .order(by: "timestamp", descending: true)
                .getDocuments()
            let reels = try querySnapshot.documents.compactMap { document in
                try document.data(as: ReelEntity.self)
            }
            return reels
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func fetchReels(limit: Int = 10, startAfter: DocumentSnapshot? = nil) async throws -> ([ReelEntity], DocumentSnapshot?) {
        do {
            var query: Query = db.collection(FIR_COLLECTION_REELS)
                .order(by: "timestamp", descending: true)
                .limit(to: limit)
            if let lastDocument = startAfter {
                query = query.start(afterDocument: lastDocument)
            }
            let querySnapshot = try await query.getDocuments()
            let reels = try querySnapshot.documents.compactMap { document in
                try document.data(as: ReelEntity.self)
            }
            return (reels, querySnapshot.documents.last)
            
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    func updateReel(_ reel: ReelEntity) async throws {
        do {
            try db.collection(FIR_COLLECTION_REELS).document(reel.id.uuidString).setData(from: reel)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
}

extension FIRDatabaseService {
    func fetchComments(forPostID postID: String) async throws -> [CommentEntity] {
        do {
            let query: Query = db.collection(FIR_COLLECTION_COMMENTS)
                .document(postID)
                .collection(FIR_COLLECTION_COMMENTS)
                .order(by: "timestamp", descending: true)
            let querySnapshot = try await query.getDocuments()
            let comments = try querySnapshot.documents.compactMap { document in
                try document.data(as: CommentEntity.self)
            }
            return comments
            
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
    
    /// Añade un nuevo comentario a la subcolección de comentarios de un post.
    func addComment(_ comment: CommentEntity) async throws {
        do {
            try db.collection(FIR_COLLECTION_COMMENTS)
                .document(comment.postId.uuidString)
                .collection(FIR_COLLECTION_COMMENTS)
                .document(comment.id.uuidString)
                .setData(from: comment)
        } catch {
            throw DatabaseError.unknown(error.localizedDescription)
        }
    }
}
