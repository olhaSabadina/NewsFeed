//
//  NetworkMonitor.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 27.12.2023.
//

import UIKit
import Network
import Combine

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    @Published var isConnect: Bool = false 
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let monitor: NWPathMonitor
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                guard self.isConnect == false else { return }
                self.isConnect = true
            } else {
                self.isConnect = false
            }
        }
    }
    
    func startMonitor() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
