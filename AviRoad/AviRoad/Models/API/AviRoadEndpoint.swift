//
//  AviRoadEndpoint.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation

enum AviRoadEndpoint: APIEndpoint {
  case dashboard
  case advisor(id: String)
  
  var baseURL: URL {
    return URL(string: "https://api.aviroad.com/v1")!
  }
  
  var path: String {
    switch self {
    case .advisor(let id):
      return "/advisors/\(id)"
    case .dashboard:
      return "/dashboard"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .advisor, .dashboard:
      return .get
    }
  }
  
  var mockResponseData: Data? {
    var mockData: Data? = nil
    switch self {
    case .advisor:
      mockData = loadMockData(from: "advisor")
    case .dashboard:
      mockData = loadMockData(from: "dashboard")
    }
    return mockData
  }
}

extension AviRoadEndpoint {
  func loadMockData(from filename: String) -> Data? {
      guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
          print("Mock file not found: \(filename).json")
          return nil
      }
      
      do {
          return try Data(contentsOf: url)
      } catch {
          print("Error loading mock data: \(error)")
          return nil
      }
  }
}
