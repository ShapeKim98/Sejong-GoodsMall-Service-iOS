//
//  NetworkManager.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/22.
//

import Foundation
import SwiftUI
import Network

class NetworkManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")

    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}
