//
//  ProductDetailView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI

// MARK: - ProductDetailView
struct ProductDetailView: View {
    let listing: Listing
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image
                HeroImageSection(listing: listing)
                
                // Content
                VStack(alignment: .leading, spacing: 24) {
                    // Header Info
                    HeaderInfoSection(listing: listing)
                    
                    Divider()
                    
                    // Description
                    DescriptionSection(listing: listing)
                    
                    Divider()
                    
                    // Chef Info
                    ChefInfoSection(listing: listing)
                    
                    Divider()
                    
                    // Details
                    DetailsSection(listing: listing)
                }
                .padding(20)
                .padding(.bottom, 100) // Space for bottom bar
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .top) {
            // Navigation Bar
            NavigationBar(dismiss: dismiss)
        }
        .overlay(alignment: .bottom) {
            // Bottom Contact Bar
            BottomContactBar(listing: listing)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - HeroImageSection
private struct HeroImageSection: View {
    let listing: Listing
    @State private var currentImageIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if listing.images.isEmpty {
                // Placeholder if no images
                Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(height: 360)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 48, weight: .ultraLight))
                            .foregroundColor(Color(.systemGray4))
                    )
            } else {
                TabView(selection: $currentImageIndex) {
                    ForEach(Array(listing.images.enumerated()), id: \.offset) { index, imageUrl in
                        if imageUrl.hasPrefix("http") {
                            AsyncImage(url: URL(string: imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .frame(height: 360)
                                        .overlay(
                                            ProgressView()
                                        )
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 360)
                                        .clipped()
                                case .failure(_):
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .frame(height: 360)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.system(size: 48, weight: .ultraLight))
                                                .foregroundColor(Color(.systemGray4))
                                        )
                                @unknown default:
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .frame(height: 360)
                                }
                            }
                        } else {
                            Image(imageUrl)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 360)
                                .clipped()
                        }
                    }
                }
                .frame(height: 360)
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom page indicator
                if listing.images.count > 1 {
                    HStack(spacing: 6) {
                        ForEach(0..<listing.images.count, id: \.self) { index in
                            Circle()
                                .fill(currentImageIndex == index ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 7, height: 7)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Capsule())
                    .padding(16)
                }
            }
        }
    }
}

// MARK: - NavigationBar
private struct NavigationBar: View {
    let dismiss: DismissAction
    
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
            
            Button(action: {
                // Share action
            }) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16) // Reduced from 56 to bring buttons higher
    }
}

// MARK: - HeaderInfoSection
private struct HeaderInfoSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(listing.title)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.black)
            
            // Rating and Info
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                    Text(String(format: "%.1f", listing.rating))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black)
                    Text("(127)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text(listing.cuisine)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.system(size: 12, weight: .regular))
                    Text(listing.distance)
                        .font(.system(size: 15, weight: .regular))
                }
                .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - DescriptionSection
private struct DescriptionSection: View {
    let listing: Listing
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About this dish")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Text(listing.description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
                .lineLimit(isExpanded ? nil : 3)
            
            if !isExpanded {
                Button(action: { isExpanded = true }) {
                    Text("Read more")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - ChefInfoSection
private struct ChefInfoSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Prepared by")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            HStack(spacing: 12) {
                // Chef Avatar
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(Color(.systemGray4))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Maria Garcia")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.black)
                            Text("4.9")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("•")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        
                        Text("245 dishes")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - DetailsSection
private struct DetailsSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
                DetailRow(
                    icon: "clock",
                    title: "Preparation time",
                    value: "20-30 min"
                )
                
                DetailRow(
                    icon: "flame",
                    title: "Serves",
                    value: "1-2 people"
                )
                
                DetailRow(
                    icon: "leaf",
                    title: "Dietary",
                    value: "Contains dairy, gluten"
                )
                
                DetailRow(
                    icon: "checkmark.circle",
                    title: "Availability",
                    value: listing.availability
                )
            }
        }
    }
}

// MARK: - DetailRow
private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

// MARK: - BottomContactBar
private struct BottomContactBar: View {
    let listing: Listing
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 16) {
                // Price Display
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                    Text("$\(String(format: "%.2f", listing.price))")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // Message Button
                NavigationLink(destination: MessageDetailView(
                    chefName: "Maria Garcia",
                    chefAvatar: nil,
                    dishName: listing.title
                )) {
                    HStack(spacing: 8) {
                        Image(systemName: "message")
                            .font(.system(size: 15, weight: .regular))
                        Text("Message chef")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(20)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
    }
}

// MARK: - Preview
#Preview {
    ProductDetailView(
        listing: Listing(
            title: "Homemade Pasta Carbonara",
            description: "Fresh fettuccine with creamy carbonara sauce, pancetta, and parmesan cheese. Made with love in a home kitchen.",
            cuisine: "Italian",
            price: 18.99,
            rating: 4.8,
            distance: "0.3 miles away",
            availability: "Available Now",
            images: ["pasta1", "pasta2", "pasta3"]
        )
    )
}

