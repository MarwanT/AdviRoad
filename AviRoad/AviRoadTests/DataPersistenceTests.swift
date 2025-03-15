//
//  DataPersistenceTests.swift
//  DataPersistenceTests
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import CoreData
import Testing
@testable import AviRoad

struct DataPersistenceTests {
  let mockManager: MockManager = MockManager()
  let container: NSPersistentContainer
  let sut: DataPersistence
  
  init () {
    container = mockManager.persistentContainer
    sut = CoreDataPersistence(container: container)
  }
  
  var context: NSManagedObjectContext {
    return container.viewContext
  }
  
  // MARK: Adding
  //============================================================================
  @Test("Persists an Advisor entity without accounts")
  func persistsAnAdvisorEntityWithoutAccounts() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 10, withAccounts: false)
    let structures = entities.map({ Advisor(from: $0) })
    
    // When
    for entity in entities {
      try await sut.add(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 10)
    results.forEach { entity in
      #expect(structures.contains(where: { $0 == Advisor(from: entity) }))
    }
  }
  
  @Test("Persists a well defined Advisor entity with accounts")
  func persistsAnAdvisorEntityWithAccounts() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 8, withAccounts: true)
    let structures = entities.map({ Advisor(from: $0) })
    
    // When
    for entity in entities {
      try await sut.add(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 8)
    results.forEach { entity in
      #expect(structures.contains(where: { $0 == Advisor(from: entity) }))
    }
  }
  
  @Test("Persists a Security Entity")
  func persistASecurityEntity() async throws {
    // Given
    let entities = mockManager.securityEntityInstances(context)
    let structures = entities.map({ Security(from: $0) })
    
    // When
    for entity in entities {
      try await sut.add(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<SecurityEntity> = SecurityEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 2)
    results.forEach { entity in
      let fetched = Security(from: entity)
      #expect(structures.contains(where: { $0 == fetched }) == true)
    }
  }
  
  // MARK: Removing
  //============================================================================
  @Test("Removes an advisor successfully")
  func removeAnAdvisorEntity() async throws {
    // Given
    let entity = mockManager.advisorEntityInstances(context, 1, withAccounts: true).first!
    context.insert(entity)
    try context.save()
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    var advisorsResults = (try context.fetch(fetchRequest))
    #expect(advisorsResults.count == 1)
    
    // When
    try await sut.remove(item: entity).async()
    
    // Then
    advisorsResults = try context.fetch(fetchRequest)
    #expect(advisorsResults.count == 0)
    let custodiansFetchRequest: NSFetchRequest<CustodianEntity> = CustodianEntity.fetchRequest()
    let custodiansResults = try context.fetch(custodiansFetchRequest)
    #expect(custodiansResults.count == 0)
    let accountsFetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
    let accountsResults = try context.fetch(accountsFetchRequest)
    #expect(accountsResults.count == 0)
  }
  
  @Test("Removes a security successfully")
  func removeASecurityEntity() async throws {
    // Given
    let entities = mockManager.securityEntityInstances(context)
    let targettedEntity = entities.first!
    for entity in entities {
      context.insert(entity)
    }
    try context.save()
    let fetchRequest: NSFetchRequest<SecurityEntity> = SecurityEntity.fetchRequest()
    var results = (try context.fetch(fetchRequest))
    #expect(results.count == 2)
    
    // When
    try await sut.remove(item: targettedEntity).async()
    
    // Then
    results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
    #expect(results.map({ Security(from: $0) }).contains(where: { $0 == Security(from: targettedEntity) }) == false)
  }
  
  // MARK: Fetching
  //============================================================================
  @Test("Fetches all advisor entities")
  func fetchAllClientEntities() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 5, withAccounts: true)
    entities.forEach { entity in
      context.insert(entity)
    }
    try context.save()
    
    // When
    let result = try await sut.fetchAll(AdvisorEntity.self).async()
    
    // Then
    #expect(result.count == 5)
  }
  
  @Test("Fetches a specific advisor entity")
  func fetchASpecificAdvisorEntity() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 5, withAccounts: true)
    entities.forEach { entity in
      context.insert(entity)
    }
    let targettedEntity = entities[1]
    try context.save()
    
    // When
    let result = try await sut.fetch(
      AdvisorEntity.self,
      predicate: Predicate(format: "id == %@", targettedEntity.id! as CVarArg)
    ).async()
    
    // Then
    #expect(result.count == 1)
    let original = Advisor(from: targettedEntity)
    let fetched = Advisor(from: result.first!)
    #expect(original == fetched)
  }
  
  @Test("Fetches all security entities")
  func fetchAllSecurityEntities() async throws {
    // Given
    let entities = mockManager.securityEntityInstances(context)
    entities.forEach { entity in
      context.insert(entity)
    }
    try context.save()
    
    // When
    let result = try await sut.fetchAll(SecurityEntity.self).async()
    
    // Then
    #expect(result.count == 2)
  }
  
  @Test("Fetches a specific security entity")
  func fetchASpecificSecurityEntity() async throws {
    // Given
    let entities = mockManager.securityEntityInstances(context)
    entities.forEach { entity in
      context.insert(entity)
    }
    let targettedEntity = entities[1]
    try context.save()
    
    // When
    let result = try await sut.fetch(
      SecurityEntity.self,
      predicate: Predicate(format: "id == %@", targettedEntity.id! as CVarArg)
    ).async()
    
    // Then
    #expect(result.count == 1)
    let original = Security(from: targettedEntity)
    let fetched = Security(from: result.first!)
    #expect(original == fetched)
  }
}
