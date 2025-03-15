//
//  DataPersistence.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import Combine
import CoreData
import Foundation

typealias Persistable = NSManagedObject
typealias Sorting = NSSortDescriptor
typealias Predicate = NSPredicate

enum DataPersistenceError: Error {
  case taskFailed(Error)
  case deallocated
}

protocol DataPersistence {
  var context: NSManagedObjectContext { get }
  func add(item: some Persistable) -> AnyPublisher<Void, DataPersistenceError>
  func remove(item: some Persistable) -> AnyPublisher<Void, DataPersistenceError>
  func update(item: some Persistable) -> AnyPublisher<Void, DataPersistenceError>
  func fetchAll<T: Persistable>(_ type: T.Type) -> AnyPublisher<[T], DataPersistenceError>
  func fetchAll<T: Persistable>(_ type: T.Type, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError>
  func fetch<T: Persistable>(_ type: T.Type, predicate: Predicate?) -> AnyPublisher<[T], DataPersistenceError>
  func fetch<T: Persistable>(_ type: T.Type, predicate: Predicate?, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError>
}

class CoreDataPersistence: DataPersistence {
  private let container: NSPersistentContainer
  private var cancellables = Set<AnyCancellable>()
  
  init(container: NSPersistentContainer) {
    self.container = container
  }
  
  var context: NSManagedObjectContext {
    return container.viewContext
  }
  
  func add(item: some Persistable) -> AnyPublisher<Void, DataPersistenceError> {
    return Deferred {
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.deallocated))
          return
        }
        let context = self.container.viewContext
        context.perform {
          do {
            context.insert(item)
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(.taskFailed(error)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func remove(item: some Persistable) -> AnyPublisher<Void, DataPersistenceError> {
    return Deferred {
      Future { promise in
        let context = self.container.viewContext
        context.perform {
          do {
            context.delete(item)
            try context.save()
            promise(.success(()))
          } catch {
            promise(.failure(.taskFailed(error)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func update(item: some Persistable) -> AnyPublisher<Void, DataPersistenceError> {
    return Future { promise in
      let context = self.container.viewContext
      context.perform {
        do {
          try context.save()
          promise(.success(()))
        } catch {
          promise(.failure(.taskFailed(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func fetchAll<T: Persistable>(_ type: T.Type) -> AnyPublisher<[T], DataPersistenceError> {
    return fetch(type, predicate: nil, sortBy: [])
  }
  
  func fetchAll<T: Persistable>(_ type: T.Type, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError> {
    return fetch(type, predicate: nil, sortBy: sortBy)
  }
  
  func fetch<T>(_ type: T.Type, predicate: Predicate?) -> AnyPublisher<[T], DataPersistenceError> where T : Persistable {
    return fetch(type, predicate: predicate, sortBy: [])
  }
  
  func fetch<T>(_ type: T.Type, predicate: Predicate?, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError> where T : Persistable {
    return Deferred {
      Future { promise in
        let context = self.container.viewContext
        context.perform {
          let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
          fetchRequest.predicate = predicate
          fetchRequest.sortDescriptors = sortBy.map { Sorting(key: $0.key, ascending: $0.ascending) }
          do {
            let results = try context.fetch(fetchRequest)
            promise(.success(results))
          } catch {
            promise(.failure(.taskFailed(error)))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
