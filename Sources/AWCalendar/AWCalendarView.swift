//
//  SwiftUIView.swift
//  
//
//  Created by Alvin Wu on 2/8/23.
//

import SwiftUI

public struct AWCalendarView<T>: View where T:View{
    @ObservedObject var cal : CalendarController

    var cellBuilder : (dayComponent) -> T
    
    public init(cal : CalendarController,@ViewBuilder cellbuilder :@escaping (dayComponent)-> T ){
        _cal = .init(wrappedValue: cal)
        self.cellBuilder = cellbuilder
    }
    
    public var body: some View {
        VStack(spacing: 0){
            ForEach(cal.arrayOfWeeks, id: \.self) {item in
                HStack(spacing: 0){
                    ForEach(item, id: \.self){ day in
                        VStack{
                            let date = day
                            cellBuilder(date)
                                .opacity(date.month == cal.month ? 1 : 0.4)
                                .onTapGesture {
                                    cal.onTapEnd()
                                }
                                .background(
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color.clear)
                                            .preference(key: CellPreferenceKey.self,
                                                        value: [CellPreferenceData(id: date.id,
                                                                                   bounds: geometry.frame(in: .named("Calendar Space")))]
                                            )
                                    }
                                )
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: "Calendar Space")
        .onPreferenceChange(CellPreferenceKey.self){ value in
            cal.cardsData = value
        }
        .gesture(
            DragGesture()
                .onChanged { drag in
                    if let data = cal.cardsData.first(where: {$0.bounds.contains(drag.location)}){
                        cal.selectedCardsIndices.append(data.id)
                    }
                }
                .onEnded{_ in
                    cal.onDragEnd()
                }
        )
    }
}
    
    
public struct CalendarCell : View {
    
    let item : dayComponent
    var id : UUID{
        item.id
    }
    
    var date : Date{
        item.value
    }
    
    public var body: some View {
        ZStack{
            Text(date.getDayAsString())
            Rectangle()
                .foregroundColor(.clear)
        }
    }
}   


    
struct AWSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AWCalendarView(cal: CalendarController(monthOf: 2, yearOf: 2023)){item in
            CalendarCell(item: item)
                .frame(width: 50,height: 50)
        }
    }
}

