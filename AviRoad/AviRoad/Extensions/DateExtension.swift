//
//  DateExtension.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 15/03/2025.
//

import Foundation

extension Date {
  static func fromISO8601(_ iso8601: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: iso8601)
  }
}
