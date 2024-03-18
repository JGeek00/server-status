import Foundation

func encodeCredentialsBasicAuth(username: String, password: String) -> String? {
    // Combine username and password with a colon
    let combinedString = "\(username):\(password)"
    
    // URL encode the combined string
    guard let encodedString = combinedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return nil
    }
    
    // Convert the encoded string to Data
    guard let data = encodedString.data(using: .utf8) else {
        return nil
    }
    
    // Encode the data to base64
    let base64EncodedString = data.base64EncodedString()
    
    return base64EncodedString
}
