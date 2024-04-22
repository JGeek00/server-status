import Foundation
import CoreData

func fetchInstancesCoreData() -> [ServerInstances]? {
    let persistenceController = PersistenceController.shared.container.viewContext
    
    let fetchRequest: NSFetchRequest<ServerInstances> = ServerInstances.fetchRequest()
    
    do {
        let instances = try persistenceController.fetch(fetchRequest)
        for instance in instances {
            print(instance)
        }
        return instances
    } catch {
        return nil
    }
}

func fetchDefaultInstanceCoreData() -> ServerInstances? {
    let userDefaults = UserDefaults(suiteName: groupId)
    let def = userDefaults?.string(forKey: StorageKeys.defaultServer)

    guard let defaultInstanceId = def else { return nil }
    
    let persistenceController = PersistenceController.shared.container.viewContext
    
    let fetchRequest: NSFetchRequest<ServerInstances> = ServerInstances.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [defaultInstanceId])
    
    do {
        let instances = try persistenceController.fetch(fetchRequest)
        if instances.isEmpty {
            return nil
        }
        return instances[0]
    } catch {
        return nil
    }
}
