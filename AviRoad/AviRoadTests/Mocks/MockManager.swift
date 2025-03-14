//
//  MockManager.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 13/03/2025.
//

import CoreData
@testable import AviRoad

struct MockManager {
  static var persistentContainer: NSPersistentContainer {
    let container = NSPersistentContainer(name: "ModelScheme")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Failed to load store: \(error)")
      }
    }
    return container
  }
  
  static func advisorEntityInstances(_ context: NSManagedObjectContext, _ numberOfInstances: Int) -> [AdvisorEntity] {
    var instances: [AdvisorEntity] = []
    for index in 0..<numberOfInstances {
      let entity = AdvisorEntity(context: context)
      entity.id = UUID().uuidString
        .lowercased()
      entity.firstName = "Mar\(index)"
      entity.lastName = "Tut\(index)"
      entity.totalAssets = 12345
      entity.totalClients = 9
      entity.custodians = NSSet(array: custodianEntitiesInstances(context))
      instances.append(entity)
    }
    return instances
  }
  
  static func custodianEntitiesInstances(_ context: NSManagedObjectContext) -> [CustodianEntity] {
    let shwabEntity = CustodianEntity(context: context)
    shwabEntity.id = "c5a06098-8736-4238-983c-2b191ff7f5de"
    shwabEntity.name = "Schwab"
    shwabEntity.repId = "1001"
    let fidelityEntity = CustodianEntity(context: context)
    fidelityEntity.id = "77326e8c-08d0-4960-8271-ea430693593e"
    fidelityEntity.name = "Fidelity"
    fidelityEntity.repId = "8989"
    return [shwabEntity, fidelityEntity]
  }
  
  static var firstMockAdvisor: Advisor {
    Advisor(
      id: "550e8400-e29b-41d4-a716-446655440001",
      firstName: "Randall",
      lastName: "Le Pouce",
      totalAssets: 1234567.89,
      totalClients: 12,
      totalAccounts: 15,
      custodians: [
        Custodian(id: "c5a06098-8736-4238-983c-2b191ff7f5de", name: "Schwab", repId: "1001"),
        Custodian(id: "77326e8c-08d0-4960-8271-ea430693593e", name: "Fidelity", repId: "8989")
      ],
      accounts: nil
    )
  }
}
