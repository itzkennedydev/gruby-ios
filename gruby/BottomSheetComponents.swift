//
//  BottomSheetComponents.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI
import Combine
import BottomSheet

// MARK: - BottomSheetManager
class BottomSheetManager: ObservableObject {
    @Published var isPresented = false
    @Published var selectedDetent: PresentationDetent = .fraction(0.25)
    
    func show() {
        isPresented = true
    }
    
    func hide() {
        isPresented = false
    }
}

// MARK: - BottomSheetContent
struct BottomSheetContent: View {
    @StateObject private var sheetManager = BottomSheetManager()
    
    var body: some View {
        // This will be replaced by the sheet modifier in the parent view
        EmptyView()
    }
}

// MARK: - ListingsView
struct ListingsView: View {
    let searchText: String
    
    var body: some View {
        if filteredListings.isEmpty {
            ListingsEmptyStateView(isSearching: !searchText.isEmpty)
                .padding(.horizontal, 20)
                .padding(.top, 40)
        } else {
            LazyVStack(spacing: 16) {
                ForEach(filteredListings) { listing in
                    ListingCard(listing: listing)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var filteredListings: [Listing] {
        if searchText.isEmpty {
            return sampleListings
        } else {
            return sampleListings.filter { listing in
                listing.title.localizedCaseInsensitiveContains(searchText) ||
                listing.description.localizedCaseInsensitiveContains(searchText) ||
                listing.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

// MARK: - ListingsEmptyStateView
private struct ListingsEmptyStateView: View {
    let isSearching: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: isSearching ? "magnifyingglass" : "fork.knife")
                .font(.system(size: 54, weight: .ultraLight))
                .foregroundColor(Color(.systemGray3))
            
            VStack(spacing: 10) {
                Text(isSearching ? "No Results Found" : "No Nearby Meals")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(isSearching ? "Try adjusting your search terms" : "There are no meals available in your area right now")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            if !isSearching {
                Button(action: {
                    // Expand search radius or become a host
                }) {
                    Text("Become a Host")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - DragIndicator
struct DragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
    }
}

// MARK: - HeaderView
struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

// MARK: - View Extension for Custom Corner Radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - RoundedCorner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
} 