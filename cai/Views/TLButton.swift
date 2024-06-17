//
//  TLButton.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import SwiftUI

struct TLButton: View {
    var label: String
    var backGround: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        }label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(backGround)
                
                Text(label)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    TLButton(label: "Press Button", backGround: .blue) {
        // Action
    }
}
