//
//  CheckmarkView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/30.
//

import SwiftUI

struct DrawingCheckmarkView: View {
    @State private var checkmarkAppear: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            Path { path in
                let width: CGFloat = min(reader.size.width, reader.size.height)
                let height: CGFloat = reader.size.height
                
                path.addLines([
                    .init(x: width / 2 - 4, y: height / 2),
                    .init(x: width / 2 - 1, y: height / 2 + 3),
                    .init(x: width / 2 + 5, y: height / 2 - 4)
                ])
            }
            .trim(from: 0, to: checkmarkAppear ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap:  .round))
            .animation(Animation.easeIn(duration: 0.4), value: checkmarkAppear)
            .aspectRatio(1, contentMode: .fit)
            .onAppear {
                self.checkmarkAppear.toggle()
            }
        }
        .frame(width: 20, height: 20)
        .foregroundColor(Color("main-highlight-color"))
    }
}

struct DrawingCheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingCheckmarkView()
    }
}
