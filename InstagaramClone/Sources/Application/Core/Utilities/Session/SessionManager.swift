//
//  SessionManager.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import FirebaseAuth


class SessionManager: ObservableObject {
    @Published var user: User? 
    @Published var currentUser: UserEntity?
    
    @Published var isLoadingProfile = false
    @Published var isLoadingAuthState = true
    
    private let authService: FIRAuthServiceProtocol
    private let databaseService: FIRDatabaseServiceProtocol
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    
    init(authService: FIRAuthServiceProtocol = FIRAuthService.shared,
         databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared,
         currentUser: UserEntity) {
        self.authService = authService
        self.databaseService = databaseService
        self.currentUser = currentUser
    }
    
    init(authService: FIRAuthServiceProtocol = FIRAuthService.shared,
         databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared) {
        self.authService = authService
        self.databaseService = databaseService
        startListeningFIRUser()
    }
    
    private func startListeningFIRUser() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoadingAuthState = false
            self?.user = user
            guard let uid = user?.uid else {
                return
            }
            self?.fetchCurrentUser(uid: uid)
        }
    }
    
    public func fetchCurrentUser(uid: String) {
        Task {
            await MainActor.run {
                isLoadingProfile = true
            }
            
            Task {
                do {
                    let userProfile = try await databaseService.fetchUser(id: uid)
                    await MainActor.run {
                        self.currentUser = userProfile
                        self.isLoadingProfile = false
                    }
                } catch {
                    await MainActor.run {
                        print("Error al cargar el perfil del usuario: \(error.localizedDescription)")
                    }
                }
                await MainActor.run {
                    self.isLoadingProfile = false
                }
            }
        }
    }
    
    
    deinit {
        if let handler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
        } catch {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }
}
