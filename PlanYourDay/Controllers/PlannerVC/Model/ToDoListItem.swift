//
//  ToDoListItem.swift.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import RealmSwift
import Foundation

class ToDoListItem: Object, Codable {
  @objc dynamic var id: Int = 1
  @objc dynamic var noteTitle: String = ""
  @objc dynamic var dateStart: Date = Date()
  @objc dynamic var dateFinish: Date = Date()
  @objc dynamic var descriptionText: String = ""
  @objc dynamic var image = Data()
  
  enum CodingKeys: String, CodingKey {
    case id
    case noteTitle = "name"
    case dateStart = "date_start"
    case dateFinish = "date_finish"
    case descriptionText = "description"
    case image
  }
}

extension ToDoListItem {
  
//  var dateStartTS: String {
//    return DateFormatters.stringFromDatestamp(datestamp: self.dateStart)
//  }
//
//  var dateFinish: String {
//    return DateFormatters.stringFromDatestamp(datestamp: self.dateFinishTimestamp)
//  }
}

enum DateFormatters {
  
  static var yearAndMonthAndDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }
  
  static func stringFromDatestamp(datestamp: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "ru_RU")
    let date = Date(timeIntervalSince1970: TimeInterval(datestamp))
    return formatter.string(from: date)
  }
}
