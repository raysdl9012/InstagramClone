//
//  ProjectApp
//  
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI
import Firebase
@main
struct InstagaramCloneApp: App {
    @StateObject private var sessionManager = SessionManager()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(sessionManager)
        }
    }
}
