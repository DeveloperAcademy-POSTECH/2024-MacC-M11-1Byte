//
//  testfile.swift
//  OneByte
//
//  Created by 트루디 on 11/19/24.
//

import Foundation
import SwiftUI

struct DateInputView: View {
    // DateManager instance to handle date formatting and logic
    @StateObject private var dateManager = DateManager()
    
    // State to store the selected date from the date picker
    @State private var selectedDate = Date()
    
    // State for the D-Day text
    @State private var dDayText = ""

    var body: some View {
        VStack {
            // Title for the view
            Text("날짜 입력")
                .font(.largeTitle)
                .padding(.top, 20)
            
            // Date Picker to let the user select a date
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
            
            // Display the formatted date
            Text("선택한 날짜: \(dateManager.koreanFormattedDate(for: selectedDate))")
                .font(.title2)
                .padding(.top)
            
            // Display the month and week information
            Text("이번 주차: \(dateManager.koreanMonthAndWeek(for: selectedDate))")
                .font(.title3)
                .padding(.top)
            
            // Display today's D-Day text
            Text("오늘의 D-Day: \(dateManager.getTodayDText())")
                .font(.title3)
                .padding(.top)
            
            Spacer()
        }
        .padding()
        .onChange(of: selectedDate) { newDate in
            // Update the D-Day text when the selected date changes
            self.dDayText = dateManager.getTodayDText()
        }
    }
}

struct DateInputView_Previews: PreviewProvider {
    static var previews: some View {
        DateInputView()
    }
}
