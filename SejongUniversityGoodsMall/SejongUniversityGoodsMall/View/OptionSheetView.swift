//
//  OptionSheetView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/25.
//

import SwiftUI

struct OptionSheetView: View {
    @Namespace var optionTransition
    
    @Binding var optionSelected: Bool
    
    @State var optionList: [[String]]?
    @State var selectedOptionNumber: Int = 0
    @State var addedGoods: [SampleGoodsModel]?
    @State var isSelectedOption: [Bool]?
    
    init(optionSelected: Binding<Bool>, optionList: [[String]]? = nil, addedGoods: [SampleGoodsModel]? = nil) {
        self._optionSelected = optionSelected
        self.optionList = optionList
        self.addedGoods = addedGoods
        if let list = optionList {
            self.isSelectedOption = [Bool].init(repeating: false, count: list.count)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.black.opacity(0),
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3)
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 5)
            .opacity(0.3)
            
            VStack(spacing: 0) {
                Image(systemName: "chevron.compact.down")
                    .font(.system(size: 25))
                    .foregroundColor(Color("secondary-text-color"))
                    .padding()
                
                if let list = optionList {
                    ForEach(list, id: \.hashValue) {
                        if selectedOptionNumber == 0, let index = list.firstIndex(of: $0) {
                            OptionView(selectedOptionNumber: $selectedOptionNumber, optionSelected: $optionSelected, optionNumber: index + 1, optionList: $0)
                                .matchedGeometryEffect(id: "옵션\(index + 1)", in: optionTransition)
                        } else {
                            if let index = list.firstIndex(of: $0), selectedOptionNumber == index + 1 {
                                OptionView(selectedOptionNumber: $selectedOptionNumber, optionSelected: $optionSelected, optionNumber: index + 1, optionList: $0)
                                    .matchedGeometryEffect(id: "옵션\(index + 1)", in: optionTransition)
                            }
                        }
                    }
                } else {
                    Spacer()
                }
                
                if selectedOptionNumber == 0 {
                    Spacer()
                    
                    HStack {
                        Text("상품 \(0)개")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .padding()
                        
                        Spacer()
                        
                        Text("\(0)원")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .padding()
                    }
                    .background(Color("shape-bkg-color"))
                    .padding(.bottom)
                }
                
                Spacer()
            }
            .background(.white)
        }
        .onAppear() {
            
        }
    }
}



struct OptionView: View {
    @Binding var selectedOptionNumber: Int
    @Binding var optionSelected: Bool
    
    @State var optionNumber: Int
    @State var currentOptionSelected: Bool = false
    @State var optionChevronDegree: Double = 180
    @State var optionList: [String]
    @State var selectedOption: String?
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut) {
                    selectedOptionNumber = selectedOptionNumber == 0 ? optionNumber : 0
                    optionSelected.toggle()
                }
            } label: {
                if let option = selectedOption {
                    HStack {
                        Text(option)
                            .font(.system(size: 15))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.up")
                            .font(.system(size: 15))
                            .rotationEffect(.degrees(optionChevronDegree))
                    }
                    .foregroundColor(Color("main-text-color"))
                    .padding()
                } else {
                    HStack {
                        Text("옵션\(optionNumber) 선택하기")
                            .font(.system(size: 15))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.up")
                            .font(.system(size: 15))
                            .rotationEffect(.degrees(optionChevronDegree))
                    }
                    .foregroundColor(Color("secondary-text-color"))
                    .padding()
                }
            }
            
            if currentOptionSelected {
                ScrollView {
                    ForEach(optionList, id: \.hashValue) { option in
                        Button {
                            currentOptionSelected = false
                            selectedOptionNumber = 0
                        } label: {
                            HStack {
                                Text(option)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("main-text-color"))
                                
                                Spacer()
                            }
                            .padding()
                            .background {
                                VStack {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("secondary-text-color"))
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("secondary-text-color"))
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear() {
            if selectedOptionNumber == optionNumber {
                withAnimation {
                    currentOptionSelected = true
                    optionChevronDegree = currentOptionSelected ? 0 : 180
                    
                }
            }
        }
    }
}

struct OptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        OptionSheetView(optionSelected: .constant(false))
    }
}
