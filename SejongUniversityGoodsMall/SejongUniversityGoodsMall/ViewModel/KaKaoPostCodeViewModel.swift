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
        print(message.body)
        if let data = message.body as? [String: String] {
            DispatchQueue.main.async {
                self.address = data["address"] ?? ""
                self.zipcode = data["zonecode"] ?? ""
                
                print(self.address)
                print(self.zipcode)
            }
        }
    }
}
