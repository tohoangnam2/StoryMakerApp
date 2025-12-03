//
//  ExportFlowView.swift
//  StoryMakerApp
//
//  Created by Nam To on 2/12/25.
//

import SwiftUI

struct ExportFlowView: View {

    @ObservedObject var exportingVM: ExportingViewModel

    @Binding var snapshotImage: UIImage?
    @Binding var project: MainModel?
    @Binding var goHome: Bool

    @State private var step: Int = 0   // 0 = exporting, 1 = preview

    var body: some View {
        ZStack {
            if step == 0 {

                ExportingView(
                    exportingVM: exportingVM,
                    projectID: project?.id ?? UUID(),
                    snapshot: snapshotImage ?? UIImage()
                ) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            step = 1
                        }
                    }

                }

            } else {
                HomePreview(
                    exportingVM: exportingVM,
                    snapshotImage: $snapshotImage,
                    project: $project,
                    goHome: $goHome
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(duration: 0.5), value: step)
            }
        }
    }
}


