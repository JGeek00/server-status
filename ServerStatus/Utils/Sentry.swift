import Foundation
import Sentry

func startSentry() {
    if SentryConfig.enabled == true {
        loadSentry()
    }
    else {
        #if RELEASE
            loadSentry()
        #endif
    }
    
    func loadSentry() {
        SentrySDK.start { options in
            options.dsn = SentryConfig.dsn
            options.debug = false
            options.enableTracing = false
        }
    }
}
