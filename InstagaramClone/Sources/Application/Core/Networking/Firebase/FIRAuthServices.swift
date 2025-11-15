//
//  FirebaseAuth.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import FirebaseAuth
internal import Combine

// MARK: - Enum para errores personalizados
enum AuthError: LocalizedError {
    case emailAlreadyInUse
    case invalidEmail
    case weakPassword
    case userNotFound
    case wrongPassword
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Este correo electrónico ya está en uso."
        case .invalidEmail:
            return "El formato del correo electrónico no es válido."
        case .weakPassword:
            return "La contraseña es demasiado débil. Debe tener al menos 6 caracteres."
        case .userNotFound:
            return "No se encontró ninguna cuenta con este correo."
        case .wrongPassword:
            return "La contraseña es incorrecta."
        case .unknown(let message):
            return "Ha ocurrido un error desconocido: \(message)"
        }
    }
}

// MARK: - Protocolo del Servicio de Autenticación
protocol FIRAuthServiceProtocol {
    func signIn(withEmail email: String, password: String) async throws
    func signUp(withEmail email: String, password: String) async throws
    func signOut() throws
    func getUserID() -> String?
    var currentUser: User? { get }
}

// MARK: - Implementación del Servicio de Firebase
class FIRAuthService: FIRAuthServiceProtocol, ObservableObject {
    
    static let shared = FIRAuthService()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    private init() {} // Singleton pattern
    
    func signIn(withEmail email: String, password: String) async throws {
        print("[FIRAuthService] - signIn: \(email), \(password)")
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let error as AuthErrorCode {
            print("[FIRAuthService] - Erro: \(error)")
            throw AuthError.mapFirebaseError(error)
        } catch {
            throw AuthError.unknown(error.localizedDescription)
        }
    }
    
    func signUp(withEmail email: String, password: String) async throws {
        print("[FIRAuthService] - signUp: \(email), \(password)")
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch let error as AuthErrorCode {
            throw AuthError.mapFirebaseError(error)
        } catch {
            throw AuthError.unknown(error.localizedDescription)
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    public func getUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
}

// MARK: - Extensión para mapear errores de Firebase
extension AuthError {
    static func mapFirebaseError(_ error: AuthErrorCode) -> AuthError {
        switch error.code {
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail:
            return .invalidEmail
        case .weakPassword:
            return .weakPassword
        case .userNotFound:
            return .userNotFound
        case .wrongPassword:
            return .wrongPassword
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
