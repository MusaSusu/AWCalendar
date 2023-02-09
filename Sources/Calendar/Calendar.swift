import Foundation
import SwiftUI



public class CalendarController : ObservableObject {
    public private(set) var selected : Int = 0
    private(set) var daysOfMonth : [dayComponent] = []
    private(set) var weekdayStart : Int
    
    let lastDay : Date
    let numDays : Int
    
    var arrayOfWeeks : [[dayComponent]]{
        let count = daysOfMonth.count
        return stride(from: 0, to: count, by: 7).map {
            Array(daysOfMonth[$0 ..< Swift.min($0 + 7, count)])
        }
    }
    
    
    public init(monthOf: Int, yearOf : Int) {
        let calendar = Calendar.current
        var comps = DateComponents(calendar: calendar)
        comps.month = monthOf
        comps.year = yearOf
        let date = calendar.date(from: comps) ?? Date()
        let monthInterval = calendar.dateInterval(of: .month, for: date)!
        let firstDateofMonth = monthInterval.start
        let lastDateOfMonth = monthInterval.end
        self.numDays = calendar.dateComponents([.day], from: firstDateofMonth, to: lastDateOfMonth).day!
        self.weekdayStart = calendar.component(.weekday, from: date) - 1
        self.lastDay = lastDateOfMonth
        
        for i in (1...weekdayStart).reversed(){
            let day = dayComponent(value: calendar.date(byAdding: .day,value: -i ,to: firstDateofMonth)!)
            daysOfMonth.append(day)
        }
        
        for i in 0..<numDays {
            let day = dayComponent(value: calendar.date(byAdding: .day, value: i, to: firstDateofMonth)!)
            daysOfMonth.append(day)
        }
        
        for i in (0..<( 7 - (daysOfMonth.count % 7))){
            let day = dayComponent(value: calendar.date(byAdding: .day,value: i, to: lastDateOfMonth)!)
            daysOfMonth.append(day)
        }
    }
    
    public func getWeekday() -> String{
        return Calendar.current.weekdaySymbols[weekdayStart]
    }
    
    public func getDateOnTap(_ index : Int) -> Date{
        return daysOfMonth[index].value
    }
    
    /// Checks if the number of weeks spans 6 rows. Returns `true`. Else `false`.
    /// - Parameters:
    ///   - start: Day of week from the range 0-6 corresponding to Sunday - Saturday.
    /// - Returns: True for 6 weeks, else false for 5.
    private func checkNumWeeks(start: Int)-> Bool{
        let remainder = numDays - 29
        let end = start + remainder
        if end > 6{
            return true
        }
        else{
            return false
        }
    }
}


public struct dayComponent {
        
    public private(set) var value : Date
    var month : Int{
        return value.getMonthasInt()
    }
    
    public init(value : Date) {
        self.value = value
    }
}


extension Date{
    func getDayAsString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
}

extension Date{
    func getMonthasInt() -> Int{
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
}
