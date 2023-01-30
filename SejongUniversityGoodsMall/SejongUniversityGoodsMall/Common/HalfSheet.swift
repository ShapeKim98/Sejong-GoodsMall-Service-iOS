//
//  HalfSheet.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/28.
//

import SwiftUI

class ModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        view.isOpaque = false

        self.preferredContentSize = CGSize(width: 100, height: 100)

    }

}

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium()]
            presentation.prefersGrabberVisible = true
            presentation.largestUndimmedDetentIdentifier = .large
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
