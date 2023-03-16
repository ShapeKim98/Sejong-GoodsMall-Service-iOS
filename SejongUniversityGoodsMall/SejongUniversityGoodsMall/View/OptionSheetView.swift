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
    @Binding var vibrateOffset: CGFloat
    
    @State private var optionChevronDegree: Double = 180
    @State private var showMessage: Bool = false
    @State private var extendSizeOptions: Bool = false
    @State private var extendColorOptions: Bool = false
    @State private var extendNoneOption: Bool = false
    @State private var noneOption: String?
    
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.black.opacity(0),
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3)
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 5)
            .opacity(0.3)
            
            
            optionsAndSelection()
        }
    }
    
    @ViewBuilder
    func optionsAndSelection() -> some View {
        VStack(spacing: 0) {
            Image(systemName: "chevron.compact.down")
                .font(.title2)
                .foregroundColor(Color("secondary-text-color"))
                .padding(.bottom)
            
            if let goods = goodsViewModel.goodsDetail {
                if !extendSizeOptions {
                    if let colorOptions = goods.color?.components(separatedBy: ", ") {
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
                    if let sizeOptions = goods.size?.components(separatedBy: ", ") {
                        optionSelectionList(options: sizeOptions, selectedOptions: goodsViewModel.seletedGoods.size, isExtended: extendSizeOptions, optionType: .size) {
                            withAnimation(.spring()) {
                                extendSizeOptions.toggle()
                                isOptionSelected.toggle()
                                optionChevronDegree = extendSizeOptions ? 0 : 180
                            }
                        }
                    }
                }
                
                if goods.color == nil && goods.size == nil {
                    optionSelectionList(options: [goods.title], selectedOptions: noneOption, isExtended: extendNoneOption, optionType: .none) {
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
                        ZStack {
                            if goodsViewModel.completeSendCartGoods {
                                alertMessageView(message: "장바구니에 보관되었습니다.")
                                    .onAppear() {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation(.easeInOut) {
                                                goodsViewModel.completeSendCartGoods = false
                                            }
                                        }
                                    }
                            } else {
                                if goods.color != nil && goods.size != nil {
                                    if goodsViewModel.seletedGoods.color == nil {
                                        alertMessageView(message: "색상 옵션을 선택해 주세요")
                                            .modifier(VibrateAnimation(animatableData: vibrateOffset))
                                    } else if goodsViewModel.seletedGoods.size == nil {
                                        alertMessageView(message: "사이즈 옵션을 선택해 주세요")
                                            .modifier(VibrateAnimation(animatableData: vibrateOffset))
                                    } else {
                                        selectedGoodsOptions(goods: goods)
                                            .onAppear() {
                                                goodsViewModel.isSendGoodsPossible = true
                                            }
                                            .onDisappear() {
                                                goodsViewModel.isSendGoodsPossible = false
                                            }
                                    }
                                } else {
                                    if goods.color != nil {
                                        if goodsViewModel.seletedGoods.color == nil {
                                            alertMessageView(message: "색상 옵션을 선택해 주세요")
                                                .modifier(VibrateAnimation(animatableData: vibrateOffset))
                                        } else {
                                            selectedGoodsOptions(goods: goods)
                                                .onAppear() {
                                                    goodsViewModel.isSendGoodsPossible = true
                                                }
                                                .onDisappear() {
                                                    goodsViewModel.isSendGoodsPossible = false
                                                }
                                        }
                                    } else if goods.size != nil {
                                        if goodsViewModel.seletedGoods.size == nil {
                                            alertMessageView(message: "사이즈 옵션을 선택해 주세요")
                                                .modifier(VibrateAnimation(animatableData: vibrateOffset))
                                        } else {
                                            selectedGoodsOptions(goods: goods)
                                                .onAppear() {
                                                    goodsViewModel.isSendGoodsPossible = true
                                                }
                                                .onDisappear() {
                                                    goodsViewModel.isSendGoodsPossible = false
                                                }
                                        }
                                    } else {
                                        if goodsViewModel.seletedGoods.quantity < 1 {
                                            alertMessageView(message: "상품을 선택해 주세요")
                                                .modifier(VibrateAnimation(animatableData: vibrateOffset))
                                        } else {
                                            selectedGoodsOptions(goods: goods)
                                                .onAppear() {
                                                    goodsViewModel.isSendGoodsPossible = true
                                                }
                                                .onDisappear() {
                                                    goodsViewModel.isSendGoodsPossible = false
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .background(Color("shape-bkg-color"))
                    .frame(height: 140)
                    
                }
                
            }
        }
        .padding(.top)
        .background(.white)
    }
    
    @ViewBuilder
    func optionSelectionList(options: [String], selectedOptions: String?, isExtended: Bool, optionType: OptionType, titleClickAction: @escaping () -> Void) -> some View {
        VStack {
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
            
            if isExtended {
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
    func selectedGoodsOptions(goods: Goods) -> some View {
        HStack {
            Group {
                if let color = goodsViewModel.seletedGoods.color, let size = goodsViewModel.seletedGoods.size {
                    Text("\(color), \(size)")
                        .font(.footnote)
                        .fontWeight(.light)
                } else if goodsViewModel.seletedGoods.color == nil, goodsViewModel.seletedGoods.size == nil {
                    Text(goods.title)
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
                withAnimation(.easeInOut) {
                    goodsViewModel.seletedGoods.quantity -= 1
                }
            } label: {
                Label("마이너스", systemImage: "minus")
                    .labelStyle(.iconOnly)
                    .font(.caption2)
                    .foregroundColor(Color("main-text-color"))
            }
            .disabled(goodsViewModel.seletedGoods.quantity == 1)
            .frame(minWidth: 21, minHeight: 21)
            .background(Circle().fill(Color("shape-bkg-color")))
            
            Text("\(goodsViewModel.seletedGoods.quantity)")
                .font(.footnote)
                .fontWeight(.light)
            
            Button {
                withAnimation(.easeInOut) {
                    goodsViewModel.seletedGoods.quantity += 1
                }
            } label: {
                Label("플러스", systemImage: "plus")
                    .labelStyle(.iconOnly)
                    .font(.caption2)
                    .foregroundColor(Color("main-text-color"))
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
                    .foregroundColor(Color("main-text-color"))
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
        OptionSheetView(isOptionSelected: .constant(false), vibrateOffset: .constant(0))
            .environmentObject(GoodsViewModel())
    }
}
