//
//  OptionSheetView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/25.
//

import SwiftUI

struct OptionSheetView: View {
    @Namespace var optionTransition
    
    @Binding var isOptionSelected: Bool
    
    @State var addedGoods: [SampleBasketItemModel]?
    @State var currentOptions: [String]?
    @State var optionChevronDegree: Double = 180
    @State var selectedGoods: SampleGoodsModel?
    @State var message: String = ""
    @State var showMessage: Bool = false
    
    private let currentGoods: SampleGoodsModel
    
    init(isOptionSelected: Binding<Bool>, currentGoods: SampleGoodsModel) {
        self._isOptionSelected = isOptionSelected
        self.currentGoods = currentGoods
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
                
                if let list = currentGoods.options {
                    Group {
                        if !isOptionSelected {
                            ForEach(list, id: \.hashValue) {
                                if let index = list.firstIndex(of: $0) {
                                    if let specifiedOption = selectedGoods?.specifiedOption, specifiedOption.count > index {
                                        optionView(selectedOption: specifiedOption[index], options: $0, index: index)
                                            .matchedGeometryEffect(id: "옵션\(index)글자", in: optionTransition)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color("main-text-color"))
                                                    .matchedGeometryEffect(id: "옵션\(index)배경", in: optionTransition)
                                            }
                                    } else {
                                        optionView(selectedOption: nil, options: $0, index: index)
                                            .matchedGeometryEffect(id: "옵션\(index)글자", in: optionTransition)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color("secondary-text-color"))
                                                    .matchedGeometryEffect(id: "옵션\(index)배경", in: optionTransition)
                                            }
                                    }
                                }
                            }
                        } else {
                            if let options = currentOptions, let index = list.firstIndex(of: options) {
                                VStack(spacing: 0) {
                                    optionView(selectedOption: nil, options: options, index: index)
                                        .matchedGeometryEffect(id: "옵션\(index)글자", in: optionTransition)
                                    
                                    extendedOptionView(options: options, index: index)
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("secondary-text-color"))
                                        .matchedGeometryEffect(id: "옵션\(index)배경", in: optionTransition)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                } else {
                    Spacer()
                }
                
                if !isOptionSelected {
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
                    
                    Spacer()
                }
            }
            .background(.white)
            .onSubmit {
//                if let goods = selectedGoods, let currentGoodsOptions = currentGoods.options, goods.specifiedOption.count == currentGoodsOptions.count {
//                    if let adg = addedGoods, adg.contains{$0.specifiedOption == goods.specifiedOption} {
//
//                    }
//                }
            }
            .overlay {
                if showMessage {
                    alertMessageView()
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    showMessage = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func optionView(selectedOption: String?, options: [String], index: Int) -> some View {
        Button {
            withAnimation(.spring()) {
                if let goods = selectedGoods {
                    if goods.specifiedOption.count < index {
                        message = "옵션\(goods.specifiedOption.count) 먼저 선택해주세요."
                        showMessage = true
                    } else {
                        currentOptions = options
                        isOptionSelected.toggle()
                        optionChevronDegree = isOptionSelected ? 0 : 180
                    }
                } else {
                    selectedGoods = currentGoods
                    if let count = selectedGoods?.specifiedOption.count, count < index {
                        message = "옵션1 먼저 선택해주세요."
                        selectedGoods = nil
                        showMessage = true
                    } else {
                        currentOptions = options
                        isOptionSelected.toggle()
                        optionChevronDegree = isOptionSelected ? 0 : 180
                    }
                }
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
                    Text("옵션\(index + 1) 선택하기")
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
    }
    
    @ViewBuilder
    func extendedOptionView(options: [String], index: Int) -> some View {
        ScrollView {
            ForEach(options, id: \.hashValue) { option in
                Button {
                    withAnimation(.easeInOut) {
                        if let goods = selectedGoods {
                        if goods.specifiedOption.count == index {
                                selectedGoods?.specifiedOption.append(option)
                            } else {
                                selectedGoods?.specifiedOption[index] = option
                            }
                        } else {
                            selectedGoods?.specifiedOption.append(option)
                        }
                        
                        isOptionSelected = false
                    }
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
    
    @ViewBuilder
    func alertMessageView() -> some View {
        Text(message)
            .font(.system(size: 12))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(2)
            .background {
                Rectangle()
                    .foregroundColor(Color("main-text-color"))
            }
            .padding()
    }
}

struct OptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        OptionSheetView(isOptionSelected: .constant(false), currentGoods: SampleGoodsModel(name: "학과 잠바", price: 85_000, image: "sample-image1", tag: ["#새내기", "#종이"], category: .clothing, options: [["블랙", "카키", "핑크", "그린"], ["S", "M", "L", "XL"]]))
    }
}
