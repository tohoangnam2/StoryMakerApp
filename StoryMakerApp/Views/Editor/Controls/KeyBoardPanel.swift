//
//  KeyBoardPanel.swift
//  StoryMakerApp
//
//  Created by Nam To on 19/11/25.
//

import SwiftUI

struct KeyboardPanel: View {
    
    @Binding var text: String
    let isNew : Bool
    let onDone: (String,Bool) -> Void
    
    var body: some View {
        VStack{
            HStack {
                Image("img_textEdit")
                    .opacity(0)
                
                Spacer()
                
                Text("Text Edit")
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
                
                Button(action: {onDone(text,isNew)}) {
                    Image("img_bg_check")
                }
                .background(.white)
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
            .background(.white)
            
        }
       
    }
    
}

