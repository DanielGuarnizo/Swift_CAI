//
//  HeaderView.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import SwiftUI

struct HeaderView: View {
    var Title : String
    var SubTitle: String
    var angle: Double
    var backGround: Color
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(backGround)
                .rotationEffect(Angle(degrees: angle))
            
            
            VStack{
                // Title
                Text(Title)
                    .font(.system(size: 45))
                    .foregroundColor(Color.white)
                    .bold()
                
                // Subtitle 
                Text(SubTitle)
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width * 3,
            height: 300
        )
        .offset(y:-20)
    }
}

#Preview {
    HeaderView(Title: "Title", SubTitle: "SubTitle", angle: 15, backGround: .purple)
}
