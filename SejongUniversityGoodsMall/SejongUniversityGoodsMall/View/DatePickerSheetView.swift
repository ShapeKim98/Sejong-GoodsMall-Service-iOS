//
//  DatePickerSheetView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/31.
//

import SwiftUI

struct DatePickerSheetView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @Binding var userBirthdayString: String
    @Binding var showDatePicker: Bool
    
    @State var userBirthday: Date = .now
    
    let dateFormatter = DateFormatter()
    
    init(userBirthdayString: Binding<String>, showDatePicker: Binding<Bool>) {
        self._userBirthdayString = userBirthdayString
        self._showDatePicker = showDatePicker
        
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        showDatePicker = false
                        appViewModel.showMessageBoxBackground = false
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
                        appViewModel.showMessageBoxBackground = false
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
        DatePickerSheetView(userBirthdayString: .constant(""), showDatePicker: .constant(true))
            .environmentObject(AppViewModel())
    }
}
