//
//  TextView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct TextView: View {
    
    var selectedEditText: OverlayTextEditEnum
    
    var body: some View {
        
        switch selectedEditText {
        case .fontSize:
            Text("1 Family Picker")

        case .fontFamily:
            Text("2 Family Picker")

        case .colorSolid:
            Text("3 Family Picker")

        case .gradient:
          
            Text("4 Family Picker")

        case .stroke:
         
            Text("5 Family Picker")

        case .align:
            Text("6 Family Picker")

        case .background:
            Text("7 Family Picker")


        case .shadow:
            Text("8 Family Picker")


        case nil:
            ProgressView()

        }

        
        
        
        
    }
}

