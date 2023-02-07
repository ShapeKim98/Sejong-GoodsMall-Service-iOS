//
//  OptionSheetView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/25.
//

import SwiftUI

struct OptionSheetView: View {
    enum OptionType: String {
        case color = "색상"
        case size = "사이즈"
    }
    
    @Namespace var optionTransition
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @Binding var isOptionSelected: Bool
    
    @State var optionChevronDegree: Double = 180
    @State var selectedGoods: Goods?
    @State var message: String = ""
    @State var showMessage: Bool = false
    @State var selectedSize: String?
    @State var extendSizeOptions: Bool = false
    @State var selectedColor: String?
    @State var extendColorOptions: Bool = false
    @State var totalPrice: Int = 0
    
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
                    .font(.title2)
                    .foregroundColor(Color("secondary-text-color"))
                    .padding()
                
                if !extendSizeOptions {
                    if let colorOptions = goodsViewModel.goodsDetail.color?.components(separatedBy: ", ") {
                        optionSelectionList(options: colorOptions, selectedOptions: selectedColor, isExtended: extendColorOptions, optionType: .color) {
                            withAnimation(.spring()) {
                                extendColorOptions.toggle()
                                isOptionSelected.toggle()
                                optionChevronDegree = extendColorOptions ? 0 : 180
                            }
                        }
                    }
                }
                
                if !extendColorOptions {
                    if let sizeOptions = goodsViewModel.goodsDetail.size?.components(separatedBy: ", ") {
                        optionSelectionList(options: sizeOptions, selectedOptions: selectedSize, isExtended: extendSizeOptions, optionType: .size) {
                            withAnimation(.spring()) {
                                extendSizeOptions.toggle()
                                isOptionSelected.toggle()
                                optionChevronDegree = extendSizeOptions ? 0 : 180
                            }
                        }
                    }
                }
                
                Spacer()
                
                if !extendSizeOptions && !extendColorOptions {
                    HStack {
                        Text("상품 \(goodsViewModel.cart.count)개")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .padding()
                        
                        Spacer()
                        
                        Text("\(totalPrice)원")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .padding()
                            .onAppear() {
                                goodsViewModel.cart.forEach { cartGoods in
                                    totalPrice += cartGoods.price
                                }
                            }
                    }
                    .background(Color("shape-bkg-color"))
                    .padding(.bottom)
                    
                    Spacer()
                }
            }
            .background(.white)
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
    func optionSelectionList(options: [String], selectedOptions: String?, isExtended: Bool, optionType: OptionType, titleClickAction: @escaping () -> Void) -> some View {
        VStack {
            if isExtended {
                Button(action: titleClickAction) {
                    HStack {
                        Text("\(optionType.rawValue) 선택하기")
                            .font(.system(size: 15))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.up")
                            .font(.system(size: 15))
                            .rotationEffect(.degrees(optionChevronDegree))
                    }
                    .foregroundColor(Color("secondary-text-color"))
                    .padding()
                }
                .matchedGeometryEffect(id: "옵션\(optionType.rawValue)텍스트", in: optionTransition)
                
                ScrollView {
                    ForEach(options, id: \.hashValue) { option in
                        Button {
                            withAnimation(.spring()) {
                                if optionType == .size {
                                    selectedSize = option
                                    extendSizeOptions = false
                                } else {
                                    selectedColor = option
                                    extendColorOptions = false
                                }
                                
                                isOptionSelected = false
                                optionChevronDegree = 180
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
            } else {
                Button(action: titleClickAction) {
                    if let option = selectedOptions {
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
                            Text("\(optionType.rawValue) 선택하기")
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
                .matchedGeometryEffect(id: "옵션\(optionType.rawValue)텍스트", in: optionTransition)

            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(selectedOptions == nil ? Color("secondary-text-color") : Color("main-text-color"))
                        .matchedGeometryEffect(id: "옵션\(optionType.rawValue)배경", in: optionTransition)
                }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    @ViewBuilder
    func alertMessageView() -> some View {
        Text(message)
            .font(.caption)
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
        OptionSheetView(isOptionSelected: .constant(false))
            .environmentObject(GoodsViewModel())
    }
}
