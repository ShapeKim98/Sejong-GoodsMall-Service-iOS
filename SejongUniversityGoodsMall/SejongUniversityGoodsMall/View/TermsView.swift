//
//  TermsOfUserView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/10.
//

import SwiftUI
import PDFKit

struct TermsView: UIViewRepresentable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "pdf") else {
            return PDFView()
        }
        
        pdfView.document = PDFDocument(url: url)
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
}
