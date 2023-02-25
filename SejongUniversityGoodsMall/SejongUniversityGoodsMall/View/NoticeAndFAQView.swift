//
//  NoticeAndFAQView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/20.
//

import SwiftUI

struct NoticeAndFAQView: View {
    enum Page: String {
        case notice = "공지사항"
        case FAQ = "고객센터"
    }
    
    @Namespace var pageSelection
    
    @State private var page: Page = .notice
    @State private var selections: [Int: Bool] = [Int: Bool]()
    
    var body: some View {
        VStack(spacing: 0) {
            pageSeletions()
            
            switch page {
                case .notice:
                    noticeList()
                        .onDisappear() {
                            selections.removeAll()
                        }
                case .FAQ:
                    FAQList()
                        .onDisappear() {
                            selections.removeAll()
                        }
            }
            
            Spacer()
        }
        .navigationTitle(page.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .modifier(NavigationColorModifier())
    }
    
    @ViewBuilder
    func pageSeletions() -> some View {
        HStack {
            Spacer()
            
            orderTypeButton("공지사항", .notice) {
                withAnimation(.spring()) {
                    page = .notice
                }
            }
            
            Spacer(minLength: 150)
            
            orderTypeButton("FAQ", .FAQ) {
                withAnimation(.spring()) {
                    page = .FAQ
                }
            }
            
            Spacer()
        }
        .padding(.top, 10)
        .background(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
        .background(.white)
    }
    
    @ViewBuilder
    func orderTypeButton(_ title: String, _ seleted: Page, _ action: @escaping () -> Void) -> some View {
        let isSelected = page == seleted
        
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .light)
                    .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                    .padding(.bottom, 10)
            }
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .foregroundColor(Color("main-highlight-color"))
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "선택", in: pageSelection)
                }
            }
        }
    }
    
    @ViewBuilder
    func noticeList() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<2) { i in
                    notice(id: i, title: "주요 업데이트 내용", content: "1. 내 정보 페이지 와이어프레임\n2. 내 정보 상세페이지 와이어프레임 (찜하기~푸쉬알림)\n3. 로그인 전 후 페이지 제작 (내 정보)\n4. 로그인 유도 알림 제작 (로그인 없이 내 정보 눌러도 이용 가능)\n5. 오프라인 화면 구현\n6. 상세페이지 상품 삭제 버튼 구현\n7. 회원가입 ~ 비밀번호찾기 컴포넌트 제작 후 적용, back 버튼 수정", date: "23.02.11")
                        .onAppear() {
                            selections.updateValue(false, forKey: i)
                        }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func notice(id: Int, title: String, content: String, date: String) -> some View {
        let isSeleted = selections[id] ?? false
        let chevronDegree: Double = isSeleted ? 0 : 180
        
        VStack {
            Button {
                withAnimation(.easeInOut) {
                    let _ = selections.updateValue((isSeleted ? false : true), forKey: id)
                }
            } label: {
                HStack {
                    VStack {
                        HStack {
                            Text(title)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(date)
                                .font(.subheadline)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up")
                        .font(.system(size: 15))
                        .rotationEffect(.degrees(chevronDegree))
                }
                .foregroundColor(Color("main-text-color"))
            }
            
            if isSeleted {
                HStack {
                    Text(content)
                        .font(.caption)
                    .foregroundColor(Color("main-text-color"))
//                    .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .padding(.bottom)
        .background(alignment: .bottom) {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    func FAQList() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<2) { i in
                    FAQ(id: i, title: "Q. 자주 묻는 질문", content: "")
                        .onAppear() {
                            selections.updateValue(false, forKey: i)
                        }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func FAQ(id: Int, title: String, content: String) -> some View {
        let isSeleted = selections[id] ?? false
        let chevronDegree: Double = isSeleted ? 0 : 180
        
        VStack {
            Button {
                withAnimation(.easeInOut) {
                    let _ = selections.updateValue((isSeleted ? false : true), forKey: id)
                }
            } label: {
                HStack {
                    Text(title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up")
                        .font(.system(size: 15))
                        .rotationEffect(.degrees(chevronDegree))
                }
                .foregroundColor(Color("main-text-color"))
            }
            
            if isSeleted {
                HStack {
                    Text(content)
                        .font(.caption)
                    .foregroundColor(Color("main-text-color"))
                    
                    Spacer()
                }
                .padding()
            }
        }
        .padding(.bottom)
        .background(alignment: .bottom) {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 1)
        }
    }
}

struct NoticeAndFAQView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeAndFAQView()
    }
}
