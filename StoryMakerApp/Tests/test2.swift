//
//  test2.swift
//  StoryMakerApp
//
//  Created by Nam To on 26/11/25.
//

import SwiftUI

// Source - https://stackoverflow.com/q
// Posted by Iftikhar Hussain
// Retrieved 2025-11-26, License - CC BY-SA 4.0

struct Settings1: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
            VStack(alignment: .leading){
                Text("Select Mode")
                    .font(.custom("Inter-Medium", size: 22))
                Spacer()
                Button {
                    changeTheme(to: .dark)
                } label: {
                    HStack{
                        ZStack{
                            Circle()
                                .fill(colorScheme == .dark ? Color.green:Color.gray)
                                .frame(width:32 ,height: 32)
                            Circle()
                                .fill(Color.black)
                                .frame(width:30 ,height: 30)
                        }
                        Text("Dark Mode")
                            .font(.custom("Inter-Medium", size: 19))
                            .foregroundColor(Color("dayNightText"))
                            .padding(.leading)
                        Spacer()
                    }
                }
                Button {
                    changeTheme(to: .light)
                } label: {
                    HStack{
                        ZStack{
                            Circle()
                                .fill(colorScheme == .light ? Color.green:Color.gray)
                                .frame(width:32 ,height: 32)
                            Circle()
                                .fill(Color.white)
                                .frame(width:30 ,height: 30)
                        }
                        Text("White Mode")
                            .font(.custom("Inter-Medium", size: 19))
                            .foregroundColor(Color("dayNightText"))
                            .padding(.leading)
                        Spacer()
                    }
                }
                Button {
                    changeTheme(to: .device)
                } label: {
                    HStack{
                        ZStack{
                            Circle()
                                .fill(colorScheme == .light ? Color.green:Color.gray)
                                .frame(width:32 ,height: 32)
                            Circle()
                                .fill(Color.white)
                                .frame(width:30 ,height: 30)
                        }
                        Text("System Default")
                            .font(.custom("Inter-Medium", size: 19))
                            .foregroundColor(Color("dayNightText"))
                            .padding(.leading)
                        Spacer()
                    }
                }
                Spacer()
            }
            .frame(width: 300, height: 300)
            .background(Color.gray.ignoresSafeArea())
            .cornerRadius(30)
    }
    func changeTheme(to theme: Theme) {
        UserDefaults.standard.theme = theme
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle  = theme.userInterfaceStyle
    }
}
struct Settings1_Previews: PreviewProvider {
    static var previews: some View {
        Settings1()
    }
}


enum Theme: Int {
  case device
  case light
  case dark
}
extension Theme {
  var userInterfaceStyle: UIUserInterfaceStyle {
    switch self {
      case .device:
        return .unspecified
      case .light:
        return .light
      case .dark:
        return .dark
    }
  }
}

extension UserDefaults {
  var theme: Theme {
    get {
      register(defaults: [#function: Theme.device.rawValue])
      return Theme(rawValue: integer(forKey: #function)) ?? .device
    }
    set {
      set(newValue.rawValue, forKey: #function)
    }
  }
}




#Preview {
    Settings1()
}
