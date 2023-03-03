//
//  AppViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/16.
//

import Foundation
import SwiftUI
import UIKit

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
    func createMessageBox(title: String, secondaryTitle: String, mainButtonTitle: String, secondaryButtonTitle: String, mainButtonAction: @escaping () -> Void, secondaryButtonAction: @escaping () -> Void, closeButtonAction: @escaping () -> Void) {
        self.messageBoxTitle = title
        self.messageBoxSecondaryTitle = secondaryTitle
        self.messageBoxMainButtonTitle = mainButtonTitle
        self.messageBoxSecondaryButtonTitle = secondaryButtonTitle
        self.messageBoxMainButtonAction = mainButtonAction
        self.messageBoxSecondaryButtonAction = secondaryButtonAction
        self.messageBoxCloseButtonAction = closeButtonAction
    }
    
    func deleteMessageBox() {
        self.messageBoxTitle = ""
        self.messageBoxSecondaryTitle = ""
        self.messageBoxMainButtonTitle = ""
        self.messageBoxSecondaryButtonTitle = ""
        self.messageBoxMainButtonAction = {}
        self.messageBoxSecondaryButtonAction = {}
        self.messageBoxCloseButtonAction = {}
        
        withAnimation(.spring()) {
            self.showMessageBoxBackground = false
            self.showMessageBox = false
        }
    }
}
