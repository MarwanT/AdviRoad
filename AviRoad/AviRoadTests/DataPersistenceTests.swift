//
//  DataPersistenceTests.swift
//  DataPersistenceTests
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import CoreData
import Testing
@testable import AviRoad

@Suite(.serialized)
final class DataPersistenceTests {
  let mockManager: MockManager = MockManager()
  let container: NSPersistentContainer
  let sut: DataPersistence
  
  init () {
    container = mockManager.persistentContainer
    sut = CoreDataPersistence(container: container)
  }
  
  deinit {
    mockManager.deletePersistentStore()
  }
  
  var context: NSManagedObjectContext {
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return container.viewContext
  }
  
  // MARK: Adding
  //============================================================================
  @Test("Persists an Advisor entity without accounts")
  func persistsAnAdvisorEntityWithoutAccounts() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 1, withAccounts: false)
    let structures = entities.map({ Advisor(from: $0) })
    
    // When
    for entity in entities {
      try await sut.add(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
    results.forEach { entity in
      #expect(structures.contains(where: { $0 == Advisor(from: entity) }))
    }
  }
  
  @Test("Persists multiple Advisor entities without accounts")
  func persistsMultipleAdvisorEntityWithoutAccounts() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 18, withAccounts: false)
    let structures = entities.map({ Advisor(from: $0) })
    
    // When
    for entity in entities {
      try await sut.add(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 18)
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
  
  @Test("Adding an entity with the same id update the existing one")
  func updateExistingEntityWhenAddingAnotherTime() async throws {
    // Given
    let entity = mockManager.advisorEntityInstances(context, 1, withAccounts: false).first!
    let structure = Advisor(from: entity)
    try context.save()
    
    // When
    let similarEntity = AdvisorEntity(context: context, structure: structure)
    try await sut.add(item: similarEntity).async()
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
  }
  
  @Test("Persists Security Entities")
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
  
  // MARK: Updating
  //============================================================================
  @Test("Update a non existing advisor adds it")
  func updateANonExistingAdvisor() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 1, withAccounts: true)
    let structure = Advisor(from: entities.first!)
    
    // When
    for entity in entities {
      try await sut.update(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
    #expect(Advisor(from: results.first!) == structure)
  }
  
  @Test("Update multiple non existing advisors adds them")
  func updateMultipleNonExistingAdvisors() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 9, withAccounts: true)
    let structures = entities.map({ Advisor(from: $0) })
    
    // When
    for entity in entities {
      try await sut.update(item: entity).async()
    }
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = try context.fetch(fetchRequest)
    #expect(results.count == 9)
    results.forEach { entity in
      let fetched = Advisor(from: entity)
      #expect(structures.contains(where: { $0 == fetched }) == true)
    }
  }
  
  @Test("Updating an advisor persists the new changes")
  func updateAnExistingAdvisor() async throws {
    // Given
    let entities = mockManager.advisorEntityInstances(context, 1, withAccounts: false)
    let targettedStructure = Advisor(from: entities[0])
    try context.save()
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    var results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
    #expect(Advisor(from: results[0]) == Advisor(from: entities[0]))
    #expect(results[0].accounts?.count == 0)
    
    // When
    let accounts = mockManager.accountInstances(4)
    let newStructure = Advisor(
      id: targettedStructure.id,
      firstName: targettedStructure.firstName,
      lastName: targettedStructure.lastName,
      totalAssets: targettedStructure.totalAssets,
      totalClients: targettedStructure.totalClients,
      totalAccounts: accounts.count,
      custodians: targettedStructure.custodians,
      accounts: accounts)
    let _ = AdvisorEntity(context: context, structure: newStructure)
    try context.save()
    // Then
    results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
    let resultStructure = Advisor(from:results[0])
    #expect(resultStructure.accounts?.count == accounts.count)
    #expect(resultStructure == newStructure)
  }
  
  @Test("Update multiple non existing securities adds them")
  func updateMultipleNonExistingSecurities() async throws {
    // Given
    let entities = mockManager.securityEntityInstances(context)
    let structures = entities.map({ Security(from: $0) })
    
    // When
    for entity in entities {
      try await sut.update(item: entity).async()
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
  
  @Test("Updating a security persists the new changes")
  func updateAnExistingStructure() async throws {
    // Given
    let entities = mockManager.securityEntityInstances(context)
    let targettedStructure = Security(from: entities[0])
    try context.save()
    let fetchRequest: NSFetchRequest<SecurityEntity> = SecurityEntity.fetchRequest()
    var results = try context.fetch(fetchRequest)
    #expect(results.count == 2)
    
    // When
    let newStructure = Security(
      id: targettedStructure.id,
      ticker: "SMSUG",
      name: "Samsung",
      category: targettedStructure.category,
      dateAdded: targettedStructure.dateAdded
    )
    let _ = SecurityEntity(context: context, structure: newStructure)
    try context.save()
    // Then
    fetchRequest.predicate = Predicate(format: "id == %@", newStructure.id)
    results = try context.fetch(fetchRequest)
    #expect(results.count == 1)
    let resultStructure = Security(from:results[0])
    #expect(resultStructure == newStructure)
  }
  
  // MARK: Removing
  //============================================================================
  @Test("Removes an advisor successfully")
  func removeAnAdvisorEntity() async throws {
    // Given
    let entity = mockManager.advisorEntityInstances(context, 1, withAccounts: true).first!
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
    try context.save()
    let targettedEntity = entities.first!
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
    let _ = mockManager.advisorEntityInstances(context, 5, withAccounts: true)
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
    try context.save()
    let targettedEntity = entities[1]
    
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
    let _ = mockManager.securityEntityInstances(context)
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
  
  // MARK: Transforming
  //============================================================================
  @Test("Creates advisors entities from advisor structures")
  func createsAdvisorsEntitiesFromAdvisorStructures() {
    // Given
    let structures = mockManager.advisorsInstances(9)
    
    // When
    let entities = structures.map { advisor in
      context.performAndWait {
        AdvisorEntity(context: context, structure: advisor)
      }
    }
    
    // Then
    let comparables = entities.map { entity in
      Advisor(from: entity)
    }
    comparables.forEach { comparable in
      let isContained = structures.contains(where: { $0 == comparable })
      #expect(isContained == true)
    }
  }
  
  @Test("Creates securities entities from security structures")
  func createSecurityEntitiesFromSecurityStructures() {
    // Given
    let structures = mockManager.securityInstance(9)
    
    // When
    let entities = structures.map { security in
      context.performAndWait {
        SecurityEntity(context: context, structure: security)
      }
    }
    
    // Then
    let comparables = entities.map { entity in
      Security(from: entity)
    }
    comparables.forEach { comparable in
      let isContained = structures.contains(where: { $0 == comparable })
      #expect(isContained == true)
    }
  }
}
