//
//  AviRoadEndpoint.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation

enum AviRoadEndpoint: APIEndpoint {
  case dashboard
  
  var baseURL: URL {
    return URL(string: "https://api.aviroad.com/v1")!
  }
  
  var path: String {
    switch self {
    case .dashboard:
      return "/dashboard"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .dashboard:
      return .get
    }
  }
  
  var mockResponseData: Data? {
    var mockData: Data? = nil
    switch self {
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
