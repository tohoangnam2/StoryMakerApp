//
//  isConnectedToNetwork.swift
//  StoryMakerApp
//
//  Created by Nam To on 17/10/25.
//

import Network
import Combine

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isOnline: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = (path.status == .satisfied)
                print("🌐 Network status changed: \(self?.isOnline == true ? "ONLINE" : "OFFLINE")")
            }
        }
        monitor.start(queue: queue)
    }
}

