//
//  LoadingView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI

// MARK: - Constants
private enum LoadingViewConstants {
    static let logoSize: CGFloat = 200
    static let waveHeight: CGFloat = 8.0
    static let waveFrequency: CGFloat = 0.02
    static let waveAnimationDuration: TimeInterval = 2.0
    static let waveCycles: CGFloat = 3.0
    
    enum Colors {
        static let background = Color.white
        static let fillColor = Color(red: 1.0, green: 0.12, blue: 0.0) // #ff1e00
    }
}

// MARK: - LoadingView
/// A loading screen that displays a logo with a subtle pulsing animation
struct LoadingView: View {
    let progress: CGFloat
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            LogoContainer()
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .opacity(isPulsing ? 0.8 : 1.0)
        }
        .onAppear {
            startPulseAnimation()
        }
    }
    
    // MARK: - Private Methods
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isPulsing = true
        }
    }
}

// MARK: - BackgroundView
private struct BackgroundView: View {
    var body: some View {
        LoadingViewConstants.Colors.background
            .ignoresSafeArea()
    }
}

// MARK: - LogoContainer
private struct LogoContainer: View {
    var body: some View {
        Image("LoadingLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: LoadingViewConstants.logoSize, height: LoadingViewConstants.logoSize)
    }
}

// MARK: - AnimatedFillOverlay
private struct AnimatedFillOverlay: View {
    let progress: CGFloat
    let waveOffset: CGFloat
    
    var body: some View {
        Image("LoadingLogo")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: LoadingViewConstants.logoSize, height: LoadingViewConstants.logoSize)
            .foregroundColor(LoadingViewConstants.Colors.fillColor)
            .mask(
                WaveShape(progress: progress, waveOffset: waveOffset)
                    .fill(LoadingViewConstants.Colors.fillColor)
            )
    }
}

// MARK: - WaveShape
/// A custom shape that creates a wave effect for the loading animation
struct WaveShape: Shape {
    let progress: CGFloat
    let waveOffset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Start from bottom-left
        path.move(to: CGPoint(x: 0, y: height))
        
        // Draw wave line from left to right
        drawWavePath(&path, width: width, height: height)
        
        // Complete the rectangle
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
    
    // MARK: - Private Methods
    private func drawWavePath(_ path: inout Path, width: CGFloat, height: CGFloat) {
        for x in stride(from: 0, through: width, by: 1) {
            let normalizedX = x / width
            let waveY = calculateWaveY(normalizedX: normalizedX)
            let fillY = height - (progress * height) + waveY
            path.addLine(to: CGPoint(x: x, y: fillY))
        }
    }
    
    private func calculateWaveY(normalizedX: CGFloat) -> CGFloat {
        let waveArgument = (normalizedX * 2 * .pi * LoadingViewConstants.waveCycles) + waveOffset
        return sin(waveArgument) * LoadingViewConstants.waveHeight
    }
}

// MARK: - Preview
#Preview {
    LoadingView(progress: 0.5)
} 