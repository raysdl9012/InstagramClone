//
//  SplashView
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var authViewModel: AuthenticationViewModel = AuthenticationViewModel()
    var body: some View {
        ZStack {
            if sessionManager.isLoadingAuthState {
                ProgressView()
            } else if sessionManager.user != nil {
                CustomTabView()
                    .environmentObject(sessionManager)
                    .transition(.asymmetric(insertion: .scale,
                                            removal: .slide))
            } else {
                NavigationStack {
                    LoginView()
                        .environmentObject(sessionManager)
                        .transition(.move(edge: .leading))
                }
                .environmentObject(authViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: sessionManager.user)
    }
}

#Preview {
    SplashView()
        .environmentObject(SessionManager())
        .environmentObject(AuthenticationViewModel())
}
