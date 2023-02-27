//
//  AppViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/16.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showMessageBoxBackground: Bool = false
    @Published var showMessageBox: Bool = false
    @Published var messageBoxTitle: String = ""
    @Published var messageBoxSecondaryTitle: String = ""
    @Published var messageBoxMainButtonTitle: String = ""
    @Published var messageBoxSecondaryButtonTitle: String = ""
    @Published var messageBoxMainButtonAction: () -> Void = {}
    @Published var messageBoxSecondaryButtonAction: () -> Void = {}
    @Published var messageBoxCloseButtonAction: () -> Void = {}
}
