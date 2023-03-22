//
//  VibrateAnimation.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/26.
//

import SwiftUI

struct VibrateAnimation: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
