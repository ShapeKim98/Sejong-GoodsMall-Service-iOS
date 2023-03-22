//
//  TextFieldModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/02.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    @Binding var text: String
    @Binding var isValidInput: Bool
    
    @FocusState var currentField: FocusedTextField?
    
    let font: Font
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType
    let focusedTextField: FocusedTextField
    let submitLabel: SubmitLabel
    
    init(text: Binding<String>, isValidInput: Binding<Bool>, currentField: FocusState<FocusedTextField?>, font: Font, keyboardType: UIKeyboardType, contentType: UITextContentType, focusedTextField: FocusedTextField, submitLabel: SubmitLabel) {
        self._text = text
        self._isValidInput = isValidInput
        self._currentField = currentField
        self.font = font
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.focusedTextField = focusedTextField
        self.submitLabel = submitLabel
    }
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline.bold())
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .submitLabel(submitLabel)
            .focused($currentField, equals: focusedTextField)
            .padding(10)
            .background {
                textFieldBackground(isValidInput: isValidInput, input: text)
            }
    }
    
    @ViewBuilder
    func textFieldBackground(isValidInput: Bool, input: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(isValidInput || input == "" ? Color("shape-bkg-color") : Color("main-highlight-color"))
    }
}
