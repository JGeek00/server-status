import Combine
import Foundation

class StatusViewModel: ObservableObject {
    @Published var status: [StatusModel]?
    @Published var initialLoading = true
    @Published var loadError = false
    
    func fetchStatus(serverInstance: ServerInstances) async {
        let response = await ApiClient.status(
            baseUrl: generateInstanceUrl(instance: serverInstance),
            token: serverInstance.useBasicAuth ? encodeCredentialsBasicAuth(username: serverInstance.basicAuthUser!, password: serverInstance.basicAuthPassword!) : nil
        )
        
        DispatchQueue.main.async {
            self.initialLoading = false
        }
        
        if response.successful == true && response.data != nil {
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                let jsonData = try JSONSerialization.data(withJSONObject: transformStatusJSON(jsonDictionary!), options: [])
                let data = try JSONDecoder().decode(StatusModel.self, from: Data(jsonData))
                
                DispatchQueue.main.async {
                    if self.status == nil {
                        self.status = [data]
                    }
                    else {
                        self.status!.append(data)
                    }
                    self.loadError = false
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        else {
            DispatchQueue.main.async {
                self.loadError = true
            }
        }
    }
}
