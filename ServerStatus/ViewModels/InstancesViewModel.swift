import Combine
import CoreData

class InstancesViewModel: ObservableObject {
    private let persistenceController = PersistenceController.shared
    
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
        managedContext.perform {
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
            } catch {
                print("Failed to save object: \(error)")
            }
        }
    }
    
    func deleteInstance(instance: ServerInstances) {
        let managedContext = persistenceController.container.viewContext
        do {
            managedContext.delete(instance)
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to delete entity: \(error)")
        }
    }
}
