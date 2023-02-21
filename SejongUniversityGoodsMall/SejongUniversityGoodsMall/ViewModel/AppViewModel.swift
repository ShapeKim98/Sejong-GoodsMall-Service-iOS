//
//  AppViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/16.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showAlertView: Bool = false
    @Published var showMessageBox: Bool = false
    @Published var messageBox: MessageBoxView?
}
