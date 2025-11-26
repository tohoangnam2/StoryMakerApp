//
//  MailView.swift
//  StoryMakerApp
//
//  Created by Nam To on 26/11/25.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {

    @Environment(\.dismiss) var dismiss
    let subject: String
    let toEmail: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            controller.dismiss(animated: true)
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([toEmail])
        vc.setSubject(subject)
        vc.setMessageBody("", isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
