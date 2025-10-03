//
//  ProjectManager.swift
//  StoryMakerApp
//
//  Created by Nam To on 1/10/25.
//

//import SwiftUI
//
//class ProjectManager: ObservableObject {
//    @Published var editors: [UUID: BackgroundEditorViewModel] = [:]
//    
//    func editor(for project: MainModel) -> BackgroundEditorViewModel {
//        if let existing = editors[project.id] {
//            return existing
//        } else {
//            let newVM = BackgroundEditorViewModel()
//            newVM.applySettings(from: project) // load setting từ project
//            editors[project.id] = newVM
//            return newVM
//        }
//    }
//}
//extension BackgroundEditorViewModel {
//    func applySettings(from project: MainModel) {
//        self.blur       = project.blur
//        self.shadow     = project.shadow
//        self.opacity    = project.opacity
//        self.lightness  = project.lightness
//        self.saturation = project.saturation
//        self.baseImage  = project.filteredUIImage
//        self.finalImage = project.filteredUIImage
//        
//        if let img = project.filteredUIImage {
//            self.baseImage  = img
//            self.finalImage = img
//        }
//    }
//}



