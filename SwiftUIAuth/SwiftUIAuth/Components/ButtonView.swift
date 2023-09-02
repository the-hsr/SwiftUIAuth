//
//  ButtonView.swift
//  SwiftUIAuth
//
//  Created by Himanshu Singh on 02/09/23.
//

import SwiftUI

struct ButtonView: View {
    @Binding var text: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: action) {
                HStack {
                    Text(text)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: .constant("")){
            
        }
    }
}
