//
//  NetworkMonitor.swift
//  OneByte
//
//  Created by Dabin Lee on 1/23/25.
//

import Foundation
import Network
import Combine

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if let isConnected = self?.isConnected {
                print("네트워크 연결 상태: \(isConnected ? "연결됨" : "연결 안 됨")")
            }
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
