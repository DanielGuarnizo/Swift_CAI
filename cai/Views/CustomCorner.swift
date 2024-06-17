//
//  CustomCorner.swift
//  cai
//
//  Created by Daniel Guarnizo on 07/06/24.
//

import SwiftUI

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width:radius, height: radius))
        return Path(path.cgPath)
    }
}


