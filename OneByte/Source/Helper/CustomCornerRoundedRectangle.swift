//
//  CustomCornerRoundedRectangle.swift
//  OneByte
//
//  Created by 이상도 on 11/10/24.
//

import SwiftUI

struct CustomCornerRoundedRectangle: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeftRadius = min(min(topLeft, rect.width / 2), rect.height / 2)
        let topRightRadius = min(min(topRight, rect.width / 2), rect.height / 2)
        let bottomLeftRadius = min(min(bottomLeft, rect.width / 2), rect.height / 2)
        let bottomRightRadius = min(min(bottomRight, rect.width / 2), rect.height / 2)

        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))

        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius), radius: topRightRadius, startAngle: Angle.degrees(-90), endAngle: Angle.degrees(0), clockwise: false)

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius), radius: bottomRightRadius, startAngle: Angle.degrees(0), endAngle: Angle.degrees(90), clockwise: false)

        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius), radius: bottomLeftRadius, startAngle: Angle.degrees(90), endAngle: Angle.degrees(180), clockwise: false)

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius), radius: topLeftRadius, startAngle: Angle.degrees(180), endAngle: Angle.degrees(270), clockwise: false)

        return path
    }
}

