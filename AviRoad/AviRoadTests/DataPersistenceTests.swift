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
struct DataPersistenceTests {
  let container: NSPersistentContainer
  let sut: DataPersistence
  
  init () {
    container = MockManager.persistentContainer
    sut = CoreDataPersistence(container: container)
  }
  
  var context: NSManagedObjectContext {
    return container.viewContext
  }
  
  @Test("Persists a well defined Advisor entity")
  func persistsWellDefinedClientEntity() async throws {
    // Given
    let entity = MockManager.advisorEntityInstances(context, 1).first!
    
    // When
    try await sut.add(item: entity).async()
    
    // Then
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    let results = (try context.fetch(fetchRequest))
    #expect(results.count == 1)
    let originalEntity = Advisor(from: entity)
    let fetchedEntity = Advisor(from: results.first!)
    #expect(originalEntity == fetchedEntity)
  }
  
  @Test("Removes an advisor successfully")
  func removeAnAdvisorEntity() async throws {
    // Given
    let entity = MockManager.advisorEntityInstances(context, 1).first!
    context.insert(entity)
    try context.save()
    let fetchRequest: NSFetchRequest<AdvisorEntity> = AdvisorEntity.fetchRequest()
    var results = (try context.fetch(fetchRequest))
    #expect(results.count == 1)
    
    // When
    try await sut.remove(item: entity).async()
    
    // Then
    results = (try context.fetch(fetchRequest))
    #expect(results.count == 0)
  }
  

  @Test("Fetches all advisor entities")
  func fetchAllClientEntities() async throws {
    // Given
    let entities = MockManager.advisorEntityInstances(context, 5)
    entities.forEach { entity in
      context.insert(entity)
    }
    try context.save()
    
    // When
    let result = try await sut.fetchAll(AdvisorEntity.self).async()
    
    // Then
    #expect(result.count == 5)
  }
  
  @Test("Fetches a specific client entity")
  func fetchASpecificClientEntity() async throws {
    // Given
    let entities = MockManager.advisorEntityInstances(context, 5)
    entities.forEach { entity in
      context.insert(entity)
    }
    let targettedEntity = entities[1]
    try context.save()
    
    // When
    let result = try await sut.fetch(AdvisorEntity.self, predicate: Predicate(format: "id == %@", targettedEntity.id! as CVarArg)).async()
    
    // Then
    #expect(result.count == 1)
    let original = Advisor(from: targettedEntity)
    let fetched = Advisor(from: result.first!)
    #expect(original == fetched)
  }
}
