//
//  AdvisorResponse.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

struct AdvisorResponse: Codable, Equatable {
  let advisor: Advisor
  let securities: [Security]
}
