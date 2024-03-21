# Server Status
Server Status is a client for [Status](https://github.com/dani3l0/Status), a server monitoring tool. This application is created with SwiftUI for Apple devices.

### Development environment
1. Get into the project directory and run ``pod install``.
2. Create a file called ``Secrets.plist`` on the root directory, with the following structure.
- Root
    - SENTRY_DSN: sentry dsn
    - ENABLE_SENTRY: false
3. Select this file, open the inspectors, and check the mark on the Target Membership section.
