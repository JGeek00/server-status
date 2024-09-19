import Combine
import CoreData

@MainActor
class InstancesProvider: ObservableObject {
    static let shared = InstancesProvider()
    
    @Published var defaultServer = ""
    @Published var selectedInstance: ServerInstances?
    
    init() {
        let def = UserDefaults(suiteName: groupId)?.string(forKey: StorageKeys.defaultServer) ?? ""
        defaultServer = def
        if def != "" {
            let instances = fetchInstances(instanceId: def)
            if !instances.isEmpty {
                selectedInstance = instances[0]
            }
        }
        else {
            let instances = fetchInstances(instanceId: nil)
            if !instances.isEmpty {
                selectedInstance = instances[0]
            }
        }
    }
    
    private let persistenceController = PersistenceController.shared
    
    func switchInstance(instance: ServerInstances) {
        StatusProvider.shared.reset()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            self.selectedInstance = instance
            StatusProvider.shared.startTimer(interval: getRefreshTime())
        })
    }
    
    private func fetchInstances(instanceId: String?) -> [ServerInstances] {
        var data: [ServerInstances] = []
        let fetchRequest: NSFetchRequest<ServerInstances> = ServerInstances.fetchRequest()
        if instanceId != nil {
            fetchRequest.predicate = NSPredicate(format: "id == %@", instanceId! as CVarArg)
        }
        do {
            data = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
        return data
    }
    
    func createInstance(
        id: String,
        name: String,
        connectionMethod: String,
        ipDomain: String,
        port: String?,
        path: String?,
        useBasicAuth: Bool,
        basicAuthUser: String?,
        basicAuthPassword: String?
    ) -> ServerInstances? {
        let managedContext = persistenceController.container.viewContext
        let newInstance = ServerInstances(context: managedContext)
        newInstance.id = id
        newInstance.name = name
        newInstance.connectionMethod = connectionMethod
        newInstance.ipDomain = ipDomain
        newInstance.port = port
        newInstance.path = path
        newInstance.useBasicAuth = useBasicAuth
        newInstance.basicAuthUser = basicAuthUser
        newInstance.basicAuthPassword = basicAuthPassword
        
        do {
            try managedContext.save()
            
            let newInstances = fetchInstances(instanceId: nil)
            if newInstances.count == 1 {
                setDefaultInstance(instance: newInstances.first)
                DispatchQueue.main.async {
                    self.selectedInstance = newInstances.first
                }
            }
            return newInstances.first
        } catch {
            print("Failed to save object: \(error)")
            return nil
        }
    }
    
    func editInstance(
        id: String,
        name: String,
        connectionMethod: String,
        ipDomain: String,
        port: String?,
        path: String?,
        useBasicAuth: Bool,
        basicAuthUser: String?,
        basicAuthPassword: String?
    ) {
        let managedContext = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<ServerInstances> = ServerInstances.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let item = try managedContext.fetch(fetchRequest).first {
                item.name = name
                item.connectionMethod = connectionMethod
                item.ipDomain = ipDomain
                item.port = port
                item.path = path
                item.useBasicAuth = useBasicAuth
                item.basicAuthUser = basicAuthUser
                item.basicAuthPassword = basicAuthPassword

                try managedContext.save()
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func deleteInstance(instance: ServerInstances) {
        let instanceId = instance.id!
        let managedContext = persistenceController.container.viewContext
        do {
            managedContext.delete(instance)
            try managedContext.save()
            
            let instances = fetchInstances(instanceId: nil)
            if instances.isEmpty {
                StatusProvider.shared.reset()
                setDefaultInstance(instance: nil)
                self.selectedInstance = nil
            }
            else if instanceId == defaultServer {
                StatusProvider.shared.reset()
                setDefaultInstance(instance: instances[0])
                self.selectedInstance = instances[0]
                StatusProvider.shared.startTimer(interval: getRefreshTime())
            }
        } catch let error as NSError {
            print("Failed to delete entity: \(error)")
        }
    }
    
    func setDefaultInstance(instance: ServerInstances?) {
        DispatchQueue.main.async {
            self.defaultServer = instance != nil ? instance!.id! : ""
        }
        UserDefaults(suiteName: groupId)?.setValue(instance != nil ? instance!.id : nil, forKey: StorageKeys.defaultServer)
    }
}
