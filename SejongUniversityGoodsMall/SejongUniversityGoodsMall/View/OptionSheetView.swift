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
    @State var totalCount: Int = 0
    
    var body: some View {
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
            
            if !extendSizeOptions && !extendColorOptions {
                VStack(spacing: 0) {
                    HStack {
                        Text("상품 \(totalCount)개")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .onChange(of: goodsViewModel.cartRequest) { newValue in
                                totalCount = 0
                                goodsViewModel.cartRequest.forEach { goods in
                                    totalCount += goods.quantity
                                }
                            }
                        
                        Spacer()
                        
                        Text("\(totalPrice)원")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .onChange(of: totalCount) { newValue in
                                totalPrice = goodsViewModel.goodsDetail.price
                                totalPrice *= totalCount
                            }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    VStack {
                        ForEach(goodsViewModel.cartRequest, id: \.hashValue) { goods in
                            selectedGoodsOptions(goods: goods)
                        }
                        
                        Spacer()
                            .frame(maxHeight: goodsViewModel.cartRequest.count == 0 ? 100 : 70)
                    }
                }
                .background(Color("shape-bkg-color"))
            }
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
        .modifier(AddingCartModifier(goods: $goodsViewModel.goodsDetail, selectedColor: $selectedColor, seletedSize: $selectedSize))
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
                
                VStack {
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
                            .background(alignment: .top) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("secondary-text-color"))
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
    func selectedGoodsOptions(goods: CartGoodsRequest) -> some View {
            HStack {
                Group {
                    if let color = goods.color, let size = goods.size {
                        Text("\(color), \(size)")
                            .font(.footnote)
                            .fontWeight(.light)
                    } else {
                        Text("\(goods.color ?? "")\(goods.size ?? "")")
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                Button {
                    withAnimation(.spring()) {
                        goodsViewModel.subtractRequestCart(seletedColor: goods.color, seletedSize: goods.size)
                    }
                } label: {
                    Label("마이너스", systemImage: "minus")
                        .labelStyle(.iconOnly)
                        .font(.caption2)
                }
                .disabled(goods.quantity == 1)
                .frame(minWidth: 21, minHeight: 21)
                .background(Circle().fill(Color("shape-bkg-color")))
                
                Text("\(goods.quantity)")
                    .font(.footnote)
                    .fontWeight(.light)
                
                Button {
                    withAnimation(.spring()) {
                        goodsViewModel.addRequestCart(quantity: 1, seletedColor: goods.color, seletedSize: goods.size)
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
                        goodsViewModel.removeRequestCart(seletedColor: goods.color, seletedSize: goods.size)
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
            .padding(.bottom, 5)
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
