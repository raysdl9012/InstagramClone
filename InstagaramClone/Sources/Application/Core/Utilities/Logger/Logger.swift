//
//  Logger
//  
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import Foundation

enum LoggerItems {
    case camera
    case firebase
}

class Logger {
    // TODO: Implement this class
    public static func log(_ item: LoggerItems, message: String, isError: Bool = false) {
        if isError {
            let errorMessage = "❌ [\(Date())] [\(item)]: \(message)"
            print(errorMessage)
            return
        }
        print("[\(Date())] [\(item)]: \(message)")
    }
}
