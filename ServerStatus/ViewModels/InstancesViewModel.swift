import Combine
import CoreData

class InstancesViewModel: ObservableObject {
    @Published var defaultServer = ""
    
    init() {
        self.defaultServer = UserDefaults.standard.object(forKey: StorageKeys.defaultServer) as? String ?? ""
    }
    
    private let persistenceController = PersistenceController.shared
    
    private func fetchInstances() -> [ServerInstances] {
        var data: [ServerInstances] = []
        let fetchRequest: NSFetchRequest<ServerInstances> = ServerInstances.fetchRequest()
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
    ) {
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
            
            let newInstances = fetchInstances()
            if newInstances.count == 1 {
                setDefaultInstance(instance: newInstances[0])
            }
        } catch {
            print("Failed to save object: \(error)")
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
            
            let instances = fetchInstances()
            if instances.isEmpty {
                setDefaultInstance(instance: nil)
            }
            else if instanceId == defaultServer {
                setDefaultInstance(instance: instances[0])
            }
        } catch let error as NSError {
            print("Failed to delete entity: \(error)")
        }
    }
    
    func setDefaultInstance(instance: ServerInstances?) {
        defaultServer = instance != nil ? instance!.id! : ""
        UserDefaults.standard.setValue(instance != nil ? instance!.id : nil, forKey: StorageKeys.defaultServer)
    }
}
