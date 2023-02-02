//
//  DatePickerSheetView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/31.
//

import SwiftUI

struct DatePickerSheetView: View {
    @Binding var userBirthday: Date
    @Binding var userBirthdayString: String
    @Binding var showDatePicker: Bool
    
    
    let dateFormatter = DateFormatter()
    
    init(userBirthday: Binding<Date>, userBirthdayString: Binding<String>, showDatePicker: Binding<Bool>) {
        self._userBirthday = userBirthday
        self._userBirthdayString = userBirthdayString
        self._showDatePicker = showDatePicker
        
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        showDatePicker = false
                    }
                } label: {
                    Text("취소")
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-text-color"))
                }
                
                Spacer()
                
                Button {
                    userBirthdayString = dateFormatter.string(from: userBirthday)
                    withAnimation(.spring()) {
                        showDatePicker = false
                    }
                } label: {
                    Text("확인")
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-highlight-color"))
                }
            }
            .padding()
            .background(Color("shape-bkg-color"))
            
            DatePicker("날짜 선택", selection: $userBirthday, in: ...Date.now, displayedComponents: .date)
            .environment(\.locale, Locale(identifier: "ko_kr"))
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.bottom)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .ignoresSafeArea()
        }
    }
}

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(userBirthday: .constant(.now), userBirthdayString: .constant(""), showDatePicker: .constant(true))
    }
}
