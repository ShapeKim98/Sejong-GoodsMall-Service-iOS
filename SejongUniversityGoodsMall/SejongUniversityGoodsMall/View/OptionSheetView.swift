//
//  OptionSheetView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/25.
//

import SwiftUI

struct OptionSheetView: View {
    enum OptionType: String {
        case none = "상품"
        case color = "색상"
        case size = "사이즈"
    }
    
    @Namespace var optionTransition
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @Binding var isOptionSelected: Bool
    @Binding var orderType: OrderType
    
    @State private var optionChevronDegree: Double = 180
    @State private var showMessage: Bool = false
    @State private var extendSizeOptions: Bool = false
    @State private var extendColorOptions: Bool = false
    @State private var noneOption: String?
    @State private var extendNoneOption: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.black.opacity(0),
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3)
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 5)
            .opacity(0.3)
            
            orderTypeSelection()
            
            optionsAndSelection()
        }
        .onAppear() {
            print(UIDevice.current.name)
        }
    }
    
    @ViewBuilder
    func orderTypeSelection() -> some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .font(.title2)
                .foregroundColor(Color("secondary-text-color"))
                .padding(.top)
            
            HStack {
                Spacer()
                
                orderTypeButton("현장 수령", .pickUpOrder) {
                    withAnimation(.spring()) {
                        orderType = .pickUpOrder
                    }
                }
                
                Spacer(minLength: 120)
                
                orderTypeButton("택배 수령", .parcelOrder) {
                    withAnimation(.spring()) {
                        orderType = .parcelOrder
                    }
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .background {
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(Color("shape-bkg-color"))
                        .frame(height: 1)
                }
            }
        }
        .background(.white)
    }
    @ViewBuilder
    func orderTypeButton(_ title: String, _ seleted: OrderType, _ action: @escaping () -> Void) -> some View {
        let isSelected = orderType == seleted
        
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .light)
                    .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                    .padding(.horizontal, 0)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 0, height: 3)
            }
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .foregroundColor(Color("main-highlight-color"))
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "선택", in: optionTransition)
                }
            }
        }
    }
    
    @ViewBuilder
    func optionsAndSelection() -> some View {
        VStack(spacing: 0) {
            if !extendSizeOptions {
                if let colorOptions = goodsViewModel.goodsDetail.color?.components(separatedBy: ", ") {
                    optionSelectionList(options: colorOptions, selectedOptions: goodsViewModel.seletedGoods.color, isExtended: extendColorOptions, optionType: .color) {
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
                    optionSelectionList(options: sizeOptions, selectedOptions: goodsViewModel.seletedGoods.size, isExtended: extendSizeOptions, optionType: .size) {
                        withAnimation(.spring()) {
                            extendSizeOptions.toggle()
                            isOptionSelected.toggle()
                            optionChevronDegree = extendSizeOptions ? 0 : 180
                        }
                    }
                }
            }
            
            if goodsViewModel.goodsDetail.color == nil && goodsViewModel.goodsDetail.size == nil {
                optionSelectionList(options: [goodsViewModel.goodsDetail.title], selectedOptions: noneOption, isExtended: extendNoneOption, optionType: .none) {
                    withAnimation(.spring()) {
                        extendNoneOption.toggle()
                        isOptionSelected.toggle()
                        optionChevronDegree = extendNoneOption ? 0 : 180
                    }
                }
            }
            
            Spacer()
            
            if !extendSizeOptions && !extendColorOptions && !extendNoneOption {
                VStack(spacing: 0) {
                    if goodsViewModel.goodsDetail.color != nil && goodsViewModel.goodsDetail.size != nil {
                        if goodsViewModel.seletedGoods.color == nil {
                            alertMessageView(message: "색상 옵션을 선택해 주세요")
                        } else if goodsViewModel.seletedGoods.size == nil {
                            alertMessageView(message: "사이즈 옵션을 선택해 주세요")
                        } else {
                            selectedGoodsOptions()
                        }
                    } else {
                        if goodsViewModel.goodsDetail.color != nil {
                            if goodsViewModel.seletedGoods.color == nil {
                                alertMessageView(message: "색상 옵션을 선택해 주세요")
                            } else {
                                selectedGoodsOptions()
                            }
                        } else if goodsViewModel.goodsDetail.size != nil {
                            if goodsViewModel.seletedGoods.size == nil {
                                alertMessageView(message: "사이즈 옵션을 선택해 주세요")
                            } else {
                                selectedGoodsOptions()
                            }
                        } else {
                            if goodsViewModel.seletedGoods.quantity < 1 {
                                alertMessageView(message: "상품을 선택해 주세요")
                            } else {
                                selectedGoodsOptions()
                            }
                        }
                    }
                    
                    Spacer()
                }
                .background(Color("shape-bkg-color"))
                .frame(height: 140)
                
            }
        }
        .padding(.top)
        .background(.white)
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
                    VStack(spacing: 0) {
                        ForEach(options, id: \.hashValue) { option in
                            Button {
                                withAnimation(.spring()) {
                                    switch optionType {
                                        case .color:
                                            goodsViewModel.seletedGoods.color = option
                                            extendColorOptions = false
                                            break
                                        case .size:
                                            goodsViewModel.seletedGoods.size = option
                                            extendSizeOptions = false
                                            break
                                        case .none:
                                            goodsViewModel.seletedGoods.quantity = 1
                                            extendNoneOption = false
                                            break
                                    }
                                    
                                    goodsViewModel.seletedGoods.quantity = 1
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
                                .background(alignment: .top) {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("secondary-text-color"))
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
    func selectedGoodsOptions() -> some View {
            HStack {
                Group {
                    if let color = goodsViewModel.seletedGoods.color, let size = goodsViewModel.seletedGoods.size {
                        Text("\(color), \(size)")
                            .font(.footnote)
                            .fontWeight(.light)
                    } else if goodsViewModel.seletedGoods.color == nil, goodsViewModel.seletedGoods.size == nil {
                        Text(goodsViewModel.goodsDetail.title)
                            .font(.footnote)
                            .fontWeight(.light)
                    } else {
                        Text("\(goodsViewModel.seletedGoods.color ?? "")\(goodsViewModel.seletedGoods.size ?? "")")
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                Button {
                    withAnimation {
                        goodsViewModel.seletedGoods.quantity -= 1
                    }
                } label: {
                    Label("마이너스", systemImage: "minus")
                        .labelStyle(.iconOnly)
                        .font(.caption2)
                }
                .disabled(goodsViewModel.seletedGoods.quantity == 1)
                .frame(minWidth: 21, minHeight: 21)
                .background(Circle().fill(Color("shape-bkg-color")))
                
                Text("\(goodsViewModel.seletedGoods.quantity)")
                    .font(.footnote)
                    .fontWeight(.light)
                
                Button {
                    withAnimation {
                        goodsViewModel.seletedGoods.quantity += 1
                    }
                } label: {
                    Label("플러스", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.caption2)
                }
                .frame(minWidth: 21, minHeight: 21)
                .background(Circle().fill(Color("shape-bkg-color")))
                
                Spacer()
                    .frame(maxWidth: 70)
                
                Button {
                    withAnimation(.spring()) {
                        goodsViewModel.seletedGoods.color = nil
                        goodsViewModel.seletedGoods.size = nil
                        goodsViewModel.seletedGoods.quantity = 0
                    }
                } label: {
                    Label("삭제", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .frame(minWidth: 21, minHeight: 21)
                }

            }
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("main-text-color"))
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }
            }
            .padding(.horizontal)
            .frame(height: 70)
        }
    
    @ViewBuilder
    func alertMessageView(message: String) -> some View {
        HStack {
            Spacer()
            
            Text(message)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(2)
                .background {
                    Rectangle()
                        .foregroundColor(Color("main-text-color"))
                }
            
            Spacer()
        }
        .frame(height: 70)
    }
}

struct OptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        OptionSheetView(isOptionSelected: .constant(false), orderType: .constant(.pickUpOrder))
            .environmentObject(GoodsViewModel())
    }
}
