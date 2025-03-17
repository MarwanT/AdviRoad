//
//  DataPersistence.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import Combine
import CoreData
import Foundation

protocol Updatable {
  func update(entity: Self)
}

typealias Persistable = NSManagedObject & Updatable & Identifiable<String?>
typealias Sorting = NSSortDescriptor
typealias Predicate = NSPredicate

enum DataPersistenceError: Error {
  case taskFailed(Error)
  case notFound
  case deallocated
}

protocol DataPersistence {
  var context: NSManagedObjectContext { get }
  func add<T: Persistable>(item: T) -> AnyPublisher<Void, DataPersistenceError>
  func remove<T: Persistable>(item: T) -> AnyPublisher<Void, DataPersistenceError>
  func update<T: Persistable>(item: T) -> AnyPublisher<Void, DataPersistenceError>
  func fetchAll<T: Persistable>(_ type: T.Type) -> AnyPublisher<[T], DataPersistenceError>
  func fetchAll<T: Persistable>(_ type: T.Type, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError>
  func fetch<T: Persistable>(_ type: T.Type, predicate: Predicate?) -> AnyPublisher<[T], DataPersistenceError>
  func fetch<T: Persistable>(_ type: T.Type, predicate: Predicate?, sortBy: [Sorting]) -> AnyPublisher<[T], DataPersistenceError>
}

private var persistentContainer: NSPersistentContainer {
  let container = NSPersistentContainer(name: "ModelScheme")
  let description = NSPersistentStoreDescription()
  container.persistentStoreDescriptions = [description]
  container.loadPersistentStores { _, error in
    if let error = error {
      fatalError("Failed to load store: \(error)")
    }
  }
  return container
}

class CoreDataPersistence: DataPersistence {
  private let container: NSPersistentContainer
  private var cancellables = Set<AnyCancellable>()
  
  init(container: NSPersistentContainer = persistentContainer) {
    self.container = container
  }
  
  var context: NSManagedObjectContext {
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return container.viewContext
  }
  
  func add<T: Persistable>(item: T) -> AnyPublisher<Void, DataPersistenceError> {
    return Deferred {
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.deallocated))
          return
        }
        let context = self.container.viewContext
        context.perform {
          do {
            // Check if the item already exists
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id ?? "")
            let count = try context.count(for: fetchRequest)
            if count > 0 {
              // Item exists, delegate to update method
              self.update(item: item)
                .sink(receiveCompletion: { completion in
                  if case .failure(let error) = completion {
                    promise(.failure(error))
                  }
                }, receiveValue: {
                  promise(.success(()))
                })
                .store(in: &self.cancellables)
            } else {
              // Item doesn't exist, proceed to add
              context.insert(item)
              try context.save()
              promise(.success(()))
            }
          } catch {
            promise(.failure(.taskFailed(error)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func remove<T: Persistable>(item: T) -> AnyPublisher<Void, DataPersistenceError> {
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
  
  func update<T: Persistable>(item: T) -> AnyPublisher<Void, DataPersistenceError> {
    return Future { promise in
      let context = self.container.viewContext
      context.perform {
        do {
          // Fetch the existing object from the context
          let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
          fetchRequest.predicate = NSPredicate(format: "id == %@", item.id ?? "")
          let results = try context.fetch(fetchRequest)
          
          if let objectToUpdate = results.first {
            objectToUpdate.update(entity: item)
            try context.save()
            promise(.success(()))
          } else {
            // Item doesn't exist, delegate to add method
            self.add(item: item)
              .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                  promise(.failure(error))
                }
              }, receiveValue: {
                promise(.success(()))
              })
              .store(in: &self.cancellables)
          }
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
