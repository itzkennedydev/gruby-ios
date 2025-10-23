//
//  grubyApp.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI

// MARK: - Info.plist Configuration
/*
 Add these to your Info.plist file:
 
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>Gruby needs your location to find nearby meals and provide accurate delivery options.</string>
 
 <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
 <string>Gruby needs your location to find nearby meals and provide accurate delivery options.</string>
 */

// MARK: - Constants
private enum AppConstants {
    static let totalLoadingDuration: TimeInterval = 3.0
    static let frameRate: TimeInterval = 0.016 // 60 FPS for smooth animation
    static let postLoadingDelay: TimeInterval = 0.5
}

// MARK: - grubyApp
@main
struct grubyApp: App {
    @State private var isLoading = true
    @State private var loadingProgress: CGFloat = 0.0
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingView(progress: loadingProgress)
                } else {
                    ContentView()
                }
            }
            .onAppear {
                startLoadingSimulation()
            }
        }
    }
    
    // MARK: - Private Methods
    private func startLoadingSimulation() {
        let progressIncrement = AppConstants.frameRate / AppConstants.totalLoadingDuration
        
        Timer.scheduledTimer(withTimeInterval: AppConstants.frameRate, repeats: true) { timer in
            updateLoadingProgress(timer: timer, increment: progressIncrement)
        }
    }
    
    private func updateLoadingProgress(timer: Timer, increment: CGFloat) {
        withAnimation(.linear(duration: AppConstants.frameRate)) {
            loadingProgress += increment
        }
        
        if loadingProgress >= 1.0 {
            completeLoading(timer: timer)
        }
    }
    
    private func completeLoading(timer: Timer) {
        loadingProgress = 1.0
        timer.invalidate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.postLoadingDelay) {
            isLoading = false
        }
    }
}
