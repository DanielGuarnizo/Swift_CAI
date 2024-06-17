//
//  Extensions.swift
//  cai
//
//  Created by Daniel Guarnizo on 03/06/24.
//

import SwiftUI

extension View{
    // Building a Custom modifier for Custom Pop up
    func popupNavigationView<Content: View>(
        horizontalPadding: CGFloat = 40,
        show: Binding<Bool>,
        @ViewBuilder content: @escaping () ->Content
    ) -> some View{
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay {
                if show.wrappedValue{
                    // Color that will allows to overlay the popup view and be transparent
                    Color.primary
                        .opacity(0.15)
                        .ignoresSafeArea()
                    // Geometry Reader for reading Container Frame
                    GeometryReader{ proxy in
                        let size = proxy.size
                        NavigationView{
                            content()
                        }
                        .frame(width: size.width - horizontalPadding, height: size.height/1.3, alignment: .center)
                        // Corner Radius
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
    }
}

