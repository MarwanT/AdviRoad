//
//  MockManager.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 13/03/2025.
//

import CoreData
@testable import AviRoad

struct MockManager {
  var persistentContainer: NSPersistentContainer {
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
  
  func advisorEntityInstances(_ context: NSManagedObjectContext, _ numberOfInstances: Int, withAccounts: Bool) -> [AdvisorEntity] {
    var instances: [AdvisorEntity] = []
    context.performAndWait {
      for index in 0..<numberOfInstances {
        let entity = AdvisorEntity(context: context)
        entity.id = UUID().uuidString.lowercased()
        entity.firstName = "Mar\(index)"
        entity.lastName = "Tut\(index)"
        entity.totalAssets = 12345
        entity.totalClients = 9
        entity.custodians = NSSet(array: custodianEntitiesInstances(context))
        if (withAccounts) {
          entity.accounts = NSSet(array: accountEntityInstances(context, index+1))
        }
        instances.append(entity)
      }
    }
    return instances
  }
  
  func accountEntityInstances(_ context: NSManagedObjectContext, _ numberOfInstances: Int) -> [AccountEntity] {
    var instances: [AccountEntity] = []
    context.performAndWait {
      for index in 0..<numberOfInstances {
        let entity = AccountEntity(context: context)
        entity.id = UUID().uuidString.lowercased()
        entity.name = "Account Name \(index)"
        entity.clientId = UUID().uuidString.lowercased()
        entity.custodianId = UUID().uuidString.lowercased()
        entity.advisorId = UUID().uuidString.lowercased()
        entity.number = "9999\(index)"
        entity.holdings = NSSet(array: holdingEntityInstances(context, index+1))
        instances.append(entity)
      }
    }
    return instances
  }
  
  func holdingEntityInstances(_ context: NSManagedObjectContext, _ numberOfInstances: Int) -> [HoldingEntity] {
    var instances: [HoldingEntity] = []
    context.performAndWait {
      for index in 0..<numberOfInstances {
        let entity = HoldingEntity(context: context)
        entity.id = UUID().uuidString.lowercased()
        entity.ticker = "APPLE\(index)"
        entity.units = Int16(100 + index)
        entity.unitPrice = 123.45 + Double(index*3)
        instances.append(entity)
      }
    }
    return instances
  }
  
  func securityEntityInstances(_ context: NSManagedObjectContext) -> [SecurityEntity] {
    var instances: [SecurityEntity] = []
    context.performAndWait {
      let firstEntity = SecurityEntity(context: context)
      firstEntity.id = "2e5012db-3a39-415d-93b4-8b1e3b453c6c"
      firstEntity.ticker = "ICKAX"
      firstEntity.name = "Delaware Ivy Crossover Credit Fund Class A"
      firstEntity.category = "mutual-fund"
      firstEntity.dateAdded = Date.fromISO8601("2001-06-07T11:12:56.205Z")
      instances.append(firstEntity)
      let secondEntity = SecurityEntity(context: context)
      secondEntity.id = "7b90c4d5-2c17-4e7b-a4d7-1d6e2a1b3f34"
      secondEntity.ticker = "HEMCX"
      secondEntity.name = "Hartford Emerging Markets Equity Fund Class C"
      secondEntity.category = "mutual-fund"
      secondEntity.dateAdded = Date.fromISO8601("2005-09-15T14:30:22.123Z")
      instances.append(secondEntity)
    }
    return instances
  }
  
  func custodianEntitiesInstances(_ context: NSManagedObjectContext) -> [CustodianEntity] {
    var instances: [CustodianEntity] = []
    context.performAndWait {
      let shwabEntity = CustodianEntity(context: context)
      shwabEntity.id = "c5a06098-8736-4238-983c-2b191ff7f5de"
      shwabEntity.name = "Schwab"
      shwabEntity.repId = "1001"
      instances.append(shwabEntity)
      let fidelityEntity = CustodianEntity(context: context)
      fidelityEntity.id = "77326e8c-08d0-4960-8271-ea430693593e"
      fidelityEntity.name = "Fidelity"
      fidelityEntity.repId = "8989"
      instances.append(fidelityEntity)
    }
    return instances
  }
  
  var firstMockAdvisor: Advisor {
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
  
  func advisorsInstances(_ numberOfInstances: Int) -> [Advisor] {
    var instances: [Advisor] = []
    for index in 0 ..< numberOfInstances {
      let structure = Advisor(
        id: UUID().uuidString.lowercased(),
        firstName: "Mar\(index)",
        lastName: "Tut\(index)",
        totalAssets: 12345 + Double(index),
        totalClients: index + 1,
        totalAccounts: index + 2,
        custodians: custodianInstances(index+1),
        accounts: accountInstances(index+1))
      instances.append(structure)
    }
    return instances
  }
  
  func custodianInstances(_ numberOfInstances: Int) -> [Custodian] {
    var instances: [Custodian] = []
    for index in 0 ..< numberOfInstances {
      let structure = Custodian(
        id: UUID().uuidString.lowercased(),
        name: "Custodian\(index)",
        repId: "120\(index)"
      )
      instances.append(structure)
    }
    return instances
  }
  
  func accountInstances(_ numberOfInstances: Int) -> [Account] {
    var instances: [Account] = []
    for index in 0 ..< numberOfInstances {
      let structure = Account(
        id: UUID().uuidString.lowercased(),
        name: "Mar Wan \(index) 401k",
        number: "12345\(index)",
        clientId: UUID().uuidString.lowercased(),
        advisorId: UUID().uuidString.lowercased(),
        custodianId: UUID().uuidString.lowercased(),
        holdings: holdingInstance(index + 1))
      instances.append(structure)
    }
    return instances
  }
  
  func holdingInstance(_ numberOfInstances: Int) -> [Holding] {
    var instances: [Holding] = []
    for index in 0 ..< numberOfInstances {
      let structure = Holding(
        id: UUID().uuidString.lowercased(),
        ticker: "APPL\(index)",
        units: index + 1,
        unitPrice: Double(index) * 40)
      instances.append(structure)
    }
    return instances
  }
  
  func securityInstance(_ numberOfInstances: Int) -> [Security] {
    var instances: [Security] = []
    for index in 0 ..< numberOfInstances {
      let structure = Security(
        id: UUID().uuidString.lowercased(),
        ticker: "APPL\(index)",
        name: "Awsome Security",
        category: "mutual-fund",
        dateAdded: Date()
      )
      instances.append(structure)
    }
    return instances
  }
}
  
