//
//  SearchComponents.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI

// MARK: - SearchConstants
private enum SearchConstants {
    static let horizontalPadding: CGFloat = 16
    static let searchBarHeight: CGFloat = 48
    static let cornerRadius: CGFloat = 10
    static let shadowRadius: CGFloat = 2
    static let shadowOpacity: Double = 0.1
    static let topPadding: CGFloat = 8
}

// MARK: - SearchBar
struct SearchBar: View {
    @Binding var searchText: String
    @State private var isFocused = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(.systemGray2))
            
            TextField("Search for meals, restaurants...", text: $searchText)
                .font(.system(size: 16, weight: .regular))
                .textFieldStyle(PlainTextFieldStyle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFocused = true
                    }
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(.systemGray2))
                }
            }
        }
        .frame(height: 52)
        .padding(.horizontal, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .scaleEffect(isFocused ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isFocused = true
            }
        }
    }
}

// MARK: - CategoriesView
struct CategoriesView: View {
    @State private var selectedCategory: String = "All"
    
    private let categories = ["All", "Italian", "Thai", "Mexican", "Indian", "Chinese", "American", "Mediterranean"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - CategoryButton
private struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .medium : .regular))
                .foregroundColor(isSelected ? .black : Color(.secondaryLabel))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(.systemGray6) : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color(.systemGray5), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - SearchView
struct SearchView: View {
    @Binding var searchText: String
    @State private var selectedCategory: String = "All"
    
    private let categories = ["All", "Italian", "Thai", "Mexican", "Indian", "Chinese", "American", "Mediterranean"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(
                                title: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
                .padding(.top, 8)
                
                // Content based on search state
                if searchText.isEmpty {
                    // Show suggestions when not searching
                    SearchSuggestionsView()
                } else {
                    // Show search results
                    SearchResultsView(searchText: searchText, category: selectedCategory)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color.white)
    }
}

// MARK: - SearchSuggestionsView
private struct SearchSuggestionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Trending Dishes
            VStack(alignment: .leading, spacing: 16) {
                Text("Trending Near You")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(trendingDishes) { dish in
                            TrendingDishCard(dish: dish)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            // Popular Searches
            VStack(alignment: .leading, spacing: 16) {
                Text("Popular Searches")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 8) {
                    ForEach(popularSearches, id: \.self) { search in
                        PopularSearchRow(searchTerm: search)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Nearby Chefs
            VStack(alignment: .leading, spacing: 16) {
                Text("Top Rated Chefs")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    ForEach(topChefs) { chef in
                        TopChefRow(chef: chef)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - SearchResultsView
private struct SearchResultsView: View {
    let searchText: String
    let category: String
    
    var filteredResults: [TrendingDish] {
        trendingDishes.filter { dish in
            let matchesSearch = dish.name.localizedCaseInsensitiveContains(searchText) ||
                               dish.chef.localizedCaseInsensitiveContains(searchText) ||
                               dish.cuisine.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = category == "All" || dish.cuisine == category
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(filteredResults.count) results found")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
            
            if filteredResults.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 54, weight: .ultraLight))
                        .foregroundColor(Color(.systemGray3))
                    
                    VStack(spacing: 10) {
                        Text("No Results Found")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Try adjusting your search or filters\nto find what you're looking for")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 80)
                .padding(.horizontal, 32)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filteredResults) { dish in
                        SearchResultCard(dish: dish)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - TrendingDishCard
private struct TrendingDishCard: View {
    let dish: TrendingDish
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: dish.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.6))
                    )
            }
            .frame(width: 160, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dish.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(dish.chef)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text("$\(String(format: "%.2f", dish.price))")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(dish.distance)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 160)
    }
}

// MARK: - PopularSearchRow
private struct PopularSearchRow: View {
    let searchTerm: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(searchTerm)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "arrow.up.left")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - TopChefRow
private struct TopChefRow: View {
    let chef: TopChef
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: chef.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chef.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Text(String(format: "%.1f", chef.rating))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(chef.dishCount) dishes")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - SearchResultCard
private struct SearchResultCard: View {
    let dish: TrendingDish
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: dish.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.6))
                    )
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(dish.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(dish.chef)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.black)
                        Text(String(format: "%.1f", dish.rating))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(dish.distance)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Text("$\(String(format: "%.2f", dish.price))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - Data Models
struct TrendingDish: Identifiable {
    let id = UUID()
    let name: String
    let chef: String
    let cuisine: String
    let price: Double
    let distance: String
    let rating: Double
    let imageURL: String
}

struct TopChef: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let dishCount: Int
    let avatarURL: String
}

// MARK: - Sample Data
private let trendingDishes = [
    TrendingDish(name: "Pasta Carbonara", chef: "Maria Garcia", cuisine: "Italian", price: 18.99, distance: "0.3 mi", rating: 4.8, imageURL: "https://picsum.photos/200/150?random=1"),
    TrendingDish(name: "Spicy Thai Curry", chef: "Tony Chen", cuisine: "Thai", price: 15.50, distance: "0.7 mi", rating: 4.6, imageURL: "https://picsum.photos/200/150?random=2"),
    TrendingDish(name: "Margherita Pizza", chef: "Sarah Johnson", cuisine: "Italian", price: 19.99, distance: "0.8 mi", rating: 4.9, imageURL: "https://picsum.photos/200/150?random=3"),
    TrendingDish(name: "Chicken Shawarma", chef: "Ahmed Hassan", cuisine: "Mediterranean", price: 16.99, distance: "0.5 mi", rating: 4.7, imageURL: "https://picsum.photos/200/150?random=4"),
    TrendingDish(name: "Tacos al Pastor", chef: "Carlos Rodriguez", cuisine: "Mexican", price: 12.99, distance: "1.2 mi", rating: 4.5, imageURL: "https://picsum.photos/200/150?random=5")
]

private let popularSearches = [
    "Italian pasta",
    "Thai curry",
    "Mexican tacos",
    "Pizza",
    "Sushi",
    "Burgers"
]

private let topChefs = [
    TopChef(name: "Maria Garcia", rating: 4.9, dishCount: 24, avatarURL: "https://picsum.photos/100/100?random=10"),
    TopChef(name: "Tony Chen", rating: 4.8, dishCount: 18, avatarURL: "https://picsum.photos/100/100?random=11"),
    TopChef(name: "Sarah Johnson", rating: 4.7, dishCount: 32, avatarURL: "https://picsum.photos/100/100?random=12")
] 