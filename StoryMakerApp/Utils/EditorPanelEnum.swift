//
//  EditorPanelEnum.swift
//  StoryMakerApp
//
//  Created by Nam To on 19/11/25.
//

import Foundation

enum EditorPanelEnum: Equatable {
    case default1
    case textToolBar
    case textDetail(OverlayTextEditEnum)
    case keyboard(text: String, isNew: Bool)
    case backgroundEditor
}
