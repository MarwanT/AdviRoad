//
//  AdvisorsRepository.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 15/03/2025.
//

import Combine

protocol AdvisorsRepository {
  func fetchAdvisors() -> AnyPublisher<[Advisor], AdvisorsRepositoryError>
  func fetchAdvisor(id: String) -> AnyPublisher<Advisor?, AdvisorsRepositoryError>
}

enum AdvisorsRepositoryError: Error {
  case apiError(Error)
  case dataPersistenceError(Error)
  case deallocated
}

class DefaultAdvisorsRepository<APIClientType: APIClient>: AdvisorsRepository {
  let apiClient: APIClientType
  let dataPersistence: any DataPersistence
  private var cancellables: Set<AnyCancellable> = []
  
  init(
    apiClient: APIClientType = URLSessionAPIClient<AviRoadEndpoint>(),
    dataPersistence: some DataPersistence = CoreDataPersistence())
  {
    self.apiClient = apiClient
    self.dataPersistence = dataPersistence
  }
  
  func fetchAdvisors() -> AnyPublisher<[Advisor], AdvisorsRepositoryError> {
    let endpoint = AviRoadEndpoint.dashboard as! APIClientType.EndpointType
    return apiClient.request(endpoint)
      .mapError { error in AdvisorsRepositoryError.apiError(error) }
      .flatMap { [weak self] (response: DashboardResponse) -> AnyPublisher<[Advisor], AdvisorsRepositoryError> in
        guard let self = self else {
          return Fail(error: .deallocated).eraseToAnyPublisher()
        }
        let advisors = response.advisors
        return self.persistAdvisorsData(advisors)
          .map { advisors }
          .eraseToAnyPublisher()
      }
      .catch({ [weak self] _ in
        guard let self = self else {
          return Fail<[Advisor], AdvisorsRepositoryError>(error: .deallocated).eraseToAnyPublisher()
        }
        return dataPersistence.fetchAll(AdvisorEntity.self)
          .mapError({ .dataPersistenceError($0) })
          .map { entities in
            entities.map { Advisor(from: $0) }
          }
          .eraseToAnyPublisher()
      })
      .eraseToAnyPublisher()
  }
  
  func fetchAdvisor(id: String) -> AnyPublisher<Advisor?, AdvisorsRepositoryError> {
    let endpoint = AviRoadEndpoint.advisor(id: id) as! APIClientType.EndpointType
    return apiClient.request(endpoint)
      .mapError { error in AdvisorsRepositoryError.apiError(error) }
      .flatMap({ [weak self] (response: AdvisorResponse) -> AnyPublisher<Advisor?, AdvisorsRepositoryError> in
        guard let self = self else {
          return Fail(error: .deallocated).eraseToAnyPublisher()
        }
        return Publishers.Merge(
          self.persistAdvisorsData([response.advisor]),
          self.persistSecuritiesData(response.securities)
        )
        .collect()
        .map { _ in
          var advisor = response.advisor
          advisor.securities = response.securities
          return advisor
        }
        .eraseToAnyPublisher()
      })
      .catch({ [weak self] _ in
        guard let self = self else {
          return Fail<Advisor?, AdvisorsRepositoryError>(error: .deallocated).eraseToAnyPublisher()
        }
        return Publishers.Zip(
          dataPersistence.fetch(AdvisorEntity.self, predicate: Predicate(format: "id == %@", id)),
          dataPersistence.fetchAll(SecurityEntity.self))
        .mapError({ .dataPersistenceError($0) })
        .map { [weak self] (advisorEntities, securityEntities) in
          guard  let self = self, let entity = advisorEntities.first else {
            return nil
          }
          var advisor = Advisor(from: entity)
          let securities = securityEntities.map(Security.init(from:))
          addRelatedSecuritiesToAdvisor(&advisor, securities: securities)
          return advisor
        }
        .eraseToAnyPublisher()
      })
      .eraseToAnyPublisher()
  }
  
  private func persistAdvisorsData(_ advisors: [Advisor]) -> AnyPublisher<Void, AdvisorsRepositoryError> {
    let addPublishers = advisors.map { advisor in
      var entity: AdvisorEntity!
      dataPersistence.context.performAndWait {
        entity = AdvisorEntity(context: dataPersistence.context, structure: advisor)
      }
      return dataPersistence.add(item: entity)
        .mapError { AdvisorsRepositoryError.dataPersistenceError($0) }
    }
    return Publishers.MergeMany(addPublishers)
      .collect()
      .map { _ in () }
      .eraseToAnyPublisher()
  }
  
  private func persistSecuritiesData(_ securities: [Security]) -> AnyPublisher<Void, AdvisorsRepositoryError> {
    let addPublishers = securities.map { security in
      var entity: SecurityEntity!
      dataPersistence.context.performAndWait {
        entity = SecurityEntity(context: dataPersistence.context, structure: security)
      }
      return dataPersistence.add(item: entity)
        .mapError { AdvisorsRepositoryError.dataPersistenceError($0) }
    }
    return Publishers.MergeMany(addPublishers)
      .collect()
      .map { _ in () }
      .eraseToAnyPublisher()
  }
  
  private func addRelatedSecuritiesToAdvisor(_ advisor: inout Advisor, securities: [Security]) {
    guard let accounts = advisor.accounts, accounts.count > 0 else { return }
    var tickers: Set<String> = .init()
    accounts.forEach { account in
      account.holdings.forEach { holding in
        tickers.insert(holding.ticker)
      }
    }
    let relatedSecurities = securities.filter { security in
      tickers.contains(security.ticker)
    }
    advisor.securities = relatedSecurities
  }
}
