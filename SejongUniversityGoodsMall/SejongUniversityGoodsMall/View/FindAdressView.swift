//
//  FindAdressView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/05.
//

import SwiftUI
import WebKit

struct FindAdressView: UIViewRepresentable {
    @EnvironmentObject var kakaoPostCodeViewModel: KakaoPostCodeViewModel
    
    let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(request)
        webView.configuration.userContentController.add(kakaoPostCodeViewModel, name: "callBackHandler")
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<FindAdressView>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject {
        let parent: FindAdressView

        init(parent: FindAdressView) {
            self.parent = parent
        }
    }
}

struct FindAdressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FindAdressView(request: URLRequest(url: URL(string: "https://shapekim98.github.io/Sejong-University-GoodsMall-KaKao-PostCode-Service/")!))
                .environmentObject(KakaoPostCodeViewModel())
                .navigationTitle("우편번호 찾기")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
        }
    }
}
