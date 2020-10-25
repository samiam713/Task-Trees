//
//  DateCalculator.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/16/20.
//

import Foundation

var dateCalculator: DateCalculator!
class DateCalculator {
    
    let referenceDate: Date
    let today: Int
    var todayPrettyString = ""
    // var cancellable: AnyCancellable
    
    static func getPrettyString(fromDayDelta: Int) -> String {
        switch fromDayDelta {
        case 0:
            return "Done today"
        case 1:
            return "Done by tomorrow"
        case let x where x > 1:
            return "Done in \(x) days"
        default:
            return "Done \(fromDayDelta) days ago 🙃"
        }
    }
    
    func getPrettyString(fromDay: Int) -> String {
        return "\(Self.getPrettyString(fromDayDelta: fromDay - today)), \(getDateString(fromDay: fromDay))"
    }
    
    func getDateString(fromDay: Int) -> String {
        let date = referenceDate.addingTimeInterval(Double(fromDay*24*60*60))
        return date.toShortDate()
    }
    
    init() {
        let now = Date()
        let day0GMT = try! JSONDecoder().decode(Date.self, from: "618066000".data(using: .utf8)!)
        let offset = TimeZone.current.daylightSavingTimeOffset(for: now)
        let secondsFromGMT = TimeZone.current.secondsFromGMT(for: now)
        referenceDate = day0GMT.addingTimeInterval(Double(secondsFromGMT) +  offset)
        
        today = Int(referenceDate.distance(to: now)/(24.0*60*60))
        
        // cancellable = NotificationCenter.default.publisher(for: .NSCalendarDayChanged).sink(receiveValue: {_ in dateCalculator = .init()})
        
        todayPrettyString = getDateString(fromDay: today)
    }
}
