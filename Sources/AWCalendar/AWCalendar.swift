import Foundation
import SwiftUI


open class CalendarController : ObservableObject {
    private(set) var daysOfMonth : [dayComponent] = []
    private(set) var weekdayStart : Int
    private(set) var month : Int
    @Published var cardsData : [CellPreferenceData] = []
    @Published var selectedCardsIndices: [UUID] = []

    public let firstday : Date
    public let lastDay : Date
    public let numDays : Int
    
    //seperate into rows of 7 days
    var arrayOfWeeks : [[dayComponent]]{
        let count = daysOfMonth.count
        return stride(from: 0, to: count, by: 7).map {
            Array(daysOfMonth[$0 ..< Swift.min($0 + 7, count)])
        }
    }
    
    public init(monthOf: Int, yearOf : Int) {
        let calendar = Calendar.current
        let comps = DateComponents(calendar: calendar,year: yearOf,month: monthOf)
        let date = calendar.date(from: comps) ?? Date()
        let monthInterval = calendar.dateInterval(of: .month, for: date)!
        let firstDateofMonth = monthInterval.start
        let lastDateOfMonth = monthInterval.end
        self.numDays = calendar.dateComponents([.day], from: firstDateofMonth, to: lastDateOfMonth).day!
        self.weekdayStart = calendar.component(.weekday, from: date) - 1
        self.lastDay = lastDateOfMonth
        self.firstday = firstDateofMonth
        self.month = monthOf
        
        //to fill up the first row with days from prev month
        for i in (0...weekdayStart).reversed(){
            let day = dayComponent(value: calendar.date(byAdding: .day,value: -i ,to: firstDateofMonth)!)
            daysOfMonth.append(day)
        }
        
        //days of the month
        for i in 1..<numDays {
            let day = dayComponent(value: calendar.date(byAdding: .day, value: i, to: firstDateofMonth)!)
            daysOfMonth.append(day)
        }
        
        //fill up last row
        for i in (0..<( 7 - (daysOfMonth.count % 7))){
            let day = dayComponent(value: calendar.date(byAdding: .day,value: i, to: lastDateOfMonth)!)
            daysOfMonth.append(day)
        }
    }
    
    public func getWeekday() -> String{
        return Calendar.current.weekdaySymbols[weekdayStart]
    }
    
    open func onTapEnd(_ day: dayComponent){
        
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
    
    open func onDragEnd(){
        self.selectedCardsIndices = []
    }
}


public struct dayComponent: Hashable,Identifiable{
    public var id =  UUID()
    public private(set) var value : Date
    
    var month : Int{
        return value.getMonthasInt()
    }
    
    public init(value : Date) {
        self.value = value
    }
}   

struct CellPreferenceData: Equatable {
    let id: UUID
    let bounds: CGRect
}

struct CellPreferenceKey: PreferenceKey {
    typealias Value = [CellPreferenceData]
    
    static var defaultValue: [CellPreferenceData] = []
    
    static func reduce(value: inout [CellPreferenceData], nextValue: () -> [CellPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}


extension Date{
    func getDayAsString() -> String{
        let formatter = DateFormatter()
        formatter.calendar = .autoupdatingCurrent
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    func getMonthasInt() -> Int{
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(.month, from: self)
    }
}
