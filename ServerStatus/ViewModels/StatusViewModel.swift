import Combine
import Foundation

class StatusViewModel: ObservableObject {
    @Published var status: [StatusModel]?
    @Published var initialLoading = true
    @Published var loadError = false
    @Published var timer: Timer?
    @Published var selectedHardwareItem: Enums.HardwareItem?
    
    func startTimer(serverInstance: ServerInstances) {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                Task {
                    await self.fetchStatus(
                        serverInstance: serverInstance,
                        showError: self.status == nil
                    )
                }
            }
            guard let t = self.timer else { return }
            RunLoop.current.add(t, forMode: .common)
        }
    }
    
    func stopTimer() {
        guard let t = timer else { return }
        t.invalidate()
        timer = nil
    }
    
    func startDemoMode() {
        if let jsonData = statusMockData.data(using: .utf8) {
            do {
                status = try JSONDecoder().decode([StatusModel].self, from: Data(jsonData))
                initialLoading = false
                loadError = false
            } catch {
                print("Error converting string to JSON: \(error.localizedDescription)")
            }
        } else {
            print("Invalid JSON string")
        }
    }
    
    func fetchStatus(serverInstance: ServerInstances, showError: Bool) async {
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
            if showError == true {
                DispatchQueue.main.async {
                    self.loadError = true
                }
            }
        }
    }
}
