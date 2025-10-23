//
//  FavoritesView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI

// MARK: - FavoritesView
struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var favorites: [Listing] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                if favorites.isEmpty {
                    FavoritesEmptyStateView()
                        .padding(.top, 100)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(favorites) { listing in
                            ListingCard(listing: listing)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .background(Color.white)
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - FavoritesEmptyStateView
private struct FavoritesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60, weight: .ultraLight))
                .foregroundColor(Color(.systemGray3))
            
            VStack(spacing: 12) {
                Text("No Favorites Yet")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Save your favorite dishes to easily\nfind them later")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button(action: {
                // Navigate to explore
            }) {
                Text("Discover Dishes")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
}

// MARK: - Preview
#Preview {
    FavoritesView()
}

