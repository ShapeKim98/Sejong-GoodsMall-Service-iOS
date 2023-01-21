//
//  HalfSheetModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium(), .large()]
            presentation.prefersGrabberVisible = true
            presentation.largestUndimmedDetentIdentifier = .medium
        }
    }
}

struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {

    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {
    }
}

struct OptionSheetModifier: ViewModifier {
    @Binding var showSelectOption: Bool
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSelectOption) {
                if #available(iOS 16.0, *) {
                    selectOptionView()
                    .presentationDetents([.medium])
                } else {
                    HalfSheet {
                        selectOptionView()
                    }
                }
            }
    }
    
    @ViewBuilder
    func selectOptionView() -> some View {
        VStack {
            
        }
    }
}
