//
//  SplashView
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var session: SessionManager
    var body: some View {
        ZStack {
            if session.isLoggedIn {
                CustomTabView()
                    .environmentObject(session)
                    .transition(.asymmetric(insertion: .scale,
                                            removal: .slide)) 
            } else {
                NavigationStack {
                    LoginView()
                        .environmentObject(session)
                        .transition(.move(edge: .leading))
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: session.isLoggedIn)
    }
}

#Preview {
    SplashView()
        .environmentObject(SessionManager())
}
