import Foundation
import Sentry

func startSentry() {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else { return }
    guard let configDict = NSDictionary(contentsOfFile: path) else { return }
    guard let dsn = configDict["SENTRY_DSN"] else { return }
    
    if (configDict["ENABLE_SENTRY"] as? Bool) == true {
        startSentry()
    }
    else {
        #if RELEASE
            startSentry()
        #endif
    }
    
    SentrySDK.start { options in
        options.dsn = dsn as? String
        options.debug = false
        options.enableTracing = false
    }
}
