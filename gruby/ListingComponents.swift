
//
//  ListingComponents.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI


// MARK: - Listing Model
struct Listing: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let cuisine: String
    let price: Double
    let rating: Double
    let distance: String
    let availability: String
    let images: [String] // Array of image names/URLs
}

// MARK: - ListingCard
struct ListingCard: View {
    let listing: Listing
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(listing: listing)) {
            VStack(alignment: .leading, spacing: 16) {
                // Hero image section - fully rounded
                ZStack(alignment: .topTrailing) {
                    if let firstImage = listing.images.first {
                        // Try to load as URL first, fallback to asset name
                        if firstImage.hasPrefix("http") {
                            AsyncImage(url: URL(string: firstImage)) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(AppColors.neutralAccent)
                                        .frame(height: 180)
                                        .overlay(
                                            ProgressView()
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                case .failure(_):
                                    Rectangle()
                                        .fill(AppColors.neutralAccent)
                                        .frame(height: 180)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.system(size: 32, weight: .ultraLight))
                                                .foregroundColor(AppColors.secondaryColor.opacity(0.3))
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                @unknown default:
                                    Rectangle()
                                        .fill(AppColors.neutralAccent)
                                        .frame(height: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                        } else {
                            // Use local asset
                            Image(firstImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    } else {
                        // Placeholder if no images
                        Rectangle()
                            .fill(AppColors.neutralAccent)
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 32, weight: .ultraLight))
                                    .foregroundColor(AppColors.secondaryColor.opacity(0.3))
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // Image count badge (if multiple images)
                    if listing.images.count > 1 {
                        HStack(spacing: 4) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 11, weight: .medium))
                            Text("\(listing.images.count)")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(AppColors.neutralColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.primaryColor.opacity(0.8))
                        .clipShape(Capsule())
                        .padding(12)
                    }
                }
                .shadow(color: AppColors.secondaryColor.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Content section - directly in the VStack without container
                // Title
                Text(listing.title)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(2)
                    .foregroundColor(AppColors.secondaryColor)
                
                // Description
                Text(listing.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    .lineLimit(2)
                
                // Details row
                HStack(spacing: 16) {
                    // Price
                    Text("$\(String(format: "%.2f", listing.price))")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.secondaryColor)
                    
                    Text("•")
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppColors.primaryColor)
                        Text(String(format: "%.1f", listing.rating))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.secondaryColor)
                    }
                    
                    Text("•")
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    // Distance
                    Text(listing.distance)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    Spacer()
                }
                
                // Bottom info
                HStack(spacing: 8) {
                    Text(listing.cuisine)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    Text("•")
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    Text(listing.availability)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                }
            }
            .padding(.bottom, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Sample Data
let sampleListings = [
    Listing(
        title: "Homemade Pasta Carbonara",
        description: "Fresh fettuccine with creamy carbonara sauce, pancetta, and parmesan cheese. Made with love in a home kitchen.",
        cuisine: "Italian",
        price: 18.99,
        rating: 4.8,
        distance: "0.3 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800", "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800"]
    ),
    Listing(
        title: "Spicy Thai Curry",
        description: "Authentic red curry with coconut milk, vegetables, and your choice of chicken or tofu. Served with jasmine rice.",
        cuisine: "Thai",
        price: 15.50,
        rating: 4.6,
        distance: "0.7 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800", "https://images.unsplash.com/photo-1562565652-a0d8f0c59eb4?w=800"]
    ),
    Listing(
        title: "Grilled Salmon with Herbs",
        description: "Fresh Atlantic salmon grilled to perfection with lemon, herbs, and seasonal vegetables. Healthy and delicious.",
        cuisine: "Mediterranean",
        price: 22.00,
        rating: 4.9,
        distance: "1.2 miles away",
        availability: "Available in 30 min",
        images: ["https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800", "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800"]
    ),
    Listing(
        title: "Mexican Street Tacos",
        description: "Three authentic street tacos with marinated carne asada, fresh cilantro, onions, and homemade salsa verde.",
        cuisine: "Mexican",
        price: 12.99,
        rating: 4.7,
        distance: "0.5 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800", "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=800"]
    ),
    Listing(
        title: "Vegetarian Buddha Bowl",
        description: "Quinoa bowl with roasted vegetables, avocado, chickpeas, and tahini dressing. Perfect for a healthy meal.",
        cuisine: "Vegetarian",
        price: 14.50,
        rating: 4.5,
        distance: "0.9 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800", "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800"]
    ),
    Listing(
        title: "Classic Beef Burger",
        description: "Juicy beef patty with fresh lettuce, tomato, cheese, and special sauce on a toasted bun. Served with crispy fries.",
        cuisine: "American",
        price: 16.99,
        rating: 4.7,
        distance: "0.4 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800", "https://images.unsplash.com/photo-1550547660-d9450f859349?w=800"]
    ),
    Listing(
        title: "Chicken Tikka Masala",
        description: "Tender chicken in a rich, creamy tomato-based curry sauce with aromatic spices. Served with basmati rice and naan bread.",
        cuisine: "Indian",
        price: 19.50,
        rating: 4.8,
        distance: "0.8 miles away",
        availability: "Available in 15 min",
        images: ["https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800", "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800"]
    ),
    Listing(
        title: "Fresh Sushi Roll Set",
        description: "Assorted fresh sushi rolls with premium fish, avocado, and cucumber. Includes miso soup and ginger.",
        cuisine: "Japanese",
        price: 24.99,
        rating: 4.9,
        distance: "1.1 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800", "https://images.unsplash.com/photo-1563612116625-3012372fccce?w=800"]
    ),
    Listing(
        title: "Greek Gyro Plate",
        description: "Traditional gyro with lamb, tzatziki sauce, fresh vegetables, and warm pita bread. Served with Greek salad.",
        cuisine: "Greek",
        price: 17.50,
        rating: 4.6,
        distance: "0.6 miles away",
        availability: "Available Now",
        images: ["https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800", "https://images.unsplash.com/photo-1626200419199-391ae4be7a41?w=800"]
    ),
    Listing(
        title: "Korean Bibimbap",
        description: "Colorful rice bowl with marinated beef, fresh vegetables, and a perfectly fried egg. Served with gochujang sauce.",
        cuisine: "Korean",
        price: 20.99,
        rating: 4.7,
        distance: "0.9 miles away",
        availability: "Available in 20 min",
        images: ["https://images.unsplash.com/photo-1553163147-622ab57be1c7?w=800", "https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800"]
    )
] 