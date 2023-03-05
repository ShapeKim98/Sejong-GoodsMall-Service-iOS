//
//  KaKaoPostCodeViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/06.
//

import Foundation
import SwiftUI
import WebKit

class KakaoPostCodeViewModel: NSObject, ObservableObject, WKScriptMessageHandler {
    @Published var address: String?
    @Published var zipcode: String?
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: String] {
            DispatchQueue.main.async {
                self.address = data["roadAddress"] ?? ""
                self.zipcode = data["zonecode"] ?? ""
                
                print(self.address)
                print(self.zipcode)
            }
            
        }
    }
}
