//
//  DataPersistenceMock.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 16/03/2025.
//

import Combine
import CoreData
@testable import AviRoad

class DataPersistenceMock: DataPersistence {
  let container: NSPersistentContainer
  private let mockManager: MockManager = MockManager()
  private var cancellables = Set<AnyCancellable>()
  
  var advisors: [AdvisorEntity] = []
  var securities: [SecurityEntity] = []
  
  init() {
    self.container = mockManager.persistentContainer
  }
  
  var context: NSManagedObjectContext {
    return container.viewContext
  }
  
  func add(item: some NSManagedObject) -> AnyPublisher<Void, AviRoad.DataPersistenceError> {
    let itemType = type(of: item)
    switch itemType {
    case is AdvisorEntity.Type:
      advisors.append(item as! AdvisorEntity)
    case is SecurityEntity.Type:
      securities.append(item as! SecurityEntity)
    default:
      break
    }
    return Empty<Void, AviRoad.DataPersistenceError>().eraseToAnyPublisher()
  }
  
  func remove(item: some NSManagedObject) -> AnyPublisher<Void, AviRoad.DataPersistenceError> {
    let itemType = type(of: item)
    switch itemType {
    case is AdvisorEntity.Type:
      guard let index = advisors.firstIndex(where: { $0.objectID == item.objectID }) else {
        return Fail<Void, AviRoad.DataPersistenceError>(error: .notFound).eraseToAnyPublisher()
      }
      advisors.remove(at: index)
    case is SecurityEntity.Type:
      guard let index = securities.firstIndex(where: { $0.objectID == item.objectID }) else {
        return Fail<Void, AviRoad.DataPersistenceError>(error: .notFound).eraseToAnyPublisher()
      }
      securities.remove(at: index)
    default:
      break
    }
    return Empty<Void, AviRoad.DataPersistenceError>().eraseToAnyPublisher()
  }
  
  func update(item: some NSManagedObject) -> AnyPublisher<Void, AviRoad.DataPersistenceError> {
    let itemType = type(of: item)
    switch itemType {
    case is AdvisorEntity.Type:
      guard let index = advisors.firstIndex(where: { $0.objectID == item.objectID }) else {
        return Fail<Void, AviRoad.DataPersistenceError>(error: .notFound).eraseToAnyPublisher()
      }
      advisors.remove(at: index)
      advisors.insert(item as! AdvisorEntity, at: index)
    case is SecurityEntity.Type:
      guard let index = advisors.firstIndex(where: { $0.objectID == item.objectID }) else {
        return Fail<Void, AviRoad.DataPersistenceError>(error: .notFound).eraseToAnyPublisher()
      }
      securities.remove(at: index)
      securities.insert(item as! SecurityEntity, at: index)
    default:
      break
    }
    return Empty<Void, AviRoad.DataPersistenceError>().eraseToAnyPublisher()
  }
  
  func fetchAll<T: Persistable>(_ type: T.Type) -> AnyPublisher<[T], DataPersistenceError> {
    return fetch(type, predicate: nil, sortBy: [])
  }
  
  func fetchAll<T: Persistable>(_ type: T.Type, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError> {
    return fetch(type, predicate: nil, sortBy: sortBy)
  }
  
  func fetch<T>(_ type: T.Type, predicate: AviRoad.Predicate?) -> AnyPublisher<[T], DataPersistenceError> where T : Persistable {
    return fetch(type, predicate: predicate, sortBy: [])
  }
  
  func fetch<T>(_ type: T.Type, predicate: AviRoad.Predicate?, sortBy: [AviRoad.Sorting]) -> AnyPublisher<[T], AviRoad.DataPersistenceError> where T : NSManagedObject {
    if T.self == AdvisorEntity.self {
      if let _ = predicate {
        return Just([advisors[4]] as! [T])
          .setFailureType(to: AviRoad.DataPersistenceError.self)
          .eraseToAnyPublisher()
      } else {
        return Just(advisors as! [T])
          .setFailureType(to: AviRoad.DataPersistenceError.self)
          .eraseToAnyPublisher()
      }
    } else if T.self == SecurityEntity.self {
      return Just(securities as! [T])
        .setFailureType(to: AviRoad.DataPersistenceError.self)
        .eraseToAnyPublisher()
    } else {
      return Empty<[T], AviRoad.DataPersistenceError>().eraseToAnyPublisher()
    }
  }
  
  func populateSampleData() {
    advisors = mockManager.advisorEntityInstances(context, 20, withAccounts: true)
    securities = mockManager.securityEntityInstances(context)
  }
}
