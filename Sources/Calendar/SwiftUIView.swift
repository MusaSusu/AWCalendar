//
//  SwiftUIView.swift
//  
//
//  Created by Alvin Wu on 2/8/23.
//

import SwiftUI

struct CalendarView: View {
    @State var cal : CalendarController
    let dims : CGSize
    let month : Int
    let year : Int
    
    init(month: Int, year : Int,dims: CGSize){
        self.dims = dims
        self.month = month
        self.year = year
        _cal = .init(initialValue:CalendarController(monthOf: month, yearOf: year))
    }
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(cal.arrayOfWeeks.indices, id: \.self) {item in
                HStack(spacing: 0){
                    ForEach(cal.arrayOfWeeks[item].indices, id: \.self){ day in
                        VStack{
                            let date = cal.arrayOfWeeks[item][day]
                            CalendarCell(dims: 50, date: date.value)
                                .opacity(date.month == self.month ? 1 : 0.4)
                        }
                    }
                }.frame(width:dims.width,alignment: .leading)
            }
        }
    }
}
    
    
struct CalendarCell : View {
    let dims : CGFloat
    let date : Date
    
    var body: some View {
        ZStack{
            Text(date.getDayAsString())
            Rectangle()
                .foregroundColor(.clear)
            
        }
        .frame(width: dims, height: dims)
    }
}

    
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(month: 2, year: 2023,dims: CGSize(width: 400, height: 300))
    }
}
