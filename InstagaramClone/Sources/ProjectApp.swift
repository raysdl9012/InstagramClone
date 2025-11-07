//
//  ProjectApp
//  
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI

@main
struct InstagaramCloneApp: App {
    @StateObject private var session = SessionManager()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(session)
        }
    }
}
