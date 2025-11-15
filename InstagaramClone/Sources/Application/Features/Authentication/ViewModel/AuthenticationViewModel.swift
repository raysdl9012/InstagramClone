//
//  RegisterViewModel
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import Foundation
internal import Combine

class AuthenticationViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var birthDay: Date = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    @Published var registrationSuccess = false
    
    private let authService: FIRAuthServiceProtocol
    private let databaseService: FIRDatabaseServiceProtocol
    
    init(authService: FIRAuthServiceProtocol = FIRAuthService.shared,
         databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared) {
        self.authService = authService
        self.databaseService = databaseService
    }
    
    public func register() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.signUp(withEmail: email, password: password)
                guard let uid = authService.getUserID() else {
                    throw AuthError.unknown("No se pudo obtener el UID del usuario.")
                }
                let newUser = UserEntity(id: uid, name: name, lastName: "", email: email, description: "", profileImage: nil, followers: [])
                try databaseService.createUser(newUser)
                await MainActor.run {
                    self.registrationSuccess = true
                }
            } catch {
                if let authError = error as? AuthError {
                    self.errorMessage = authError.localizedDescription
                } else if let dbError = error as? DatabaseError {
                    self.errorMessage = dbError.localizedDescription
                } else {
                    self.errorMessage = "Ocurrió un error inesperado: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                self.isLoading = false
                cleanValues()
            }
        }
    }
    
    public func signIn() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.signIn(withEmail: email, password: password)
                await MainActor.run {
                    self.registrationSuccess = true
                }
            } catch {
                if let authError = error as? AuthError {
                    await MainActor.run {
                        self.errorMessage = authError.localizedDescription
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "An unexpected error occurred."
                    }
                }
            }
            await MainActor.run {
                self.isLoading = false
                cleanValues()
            }
        }
    }
    
    private func cleanValues() {
        name = ""
        email = ""
        password = ""
        birthDay = Date()
        isLoading = false
        errorMessage = nil
    }
}
