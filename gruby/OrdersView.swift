//
//  OrdersView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI

// MARK: - OrdersView
struct OrdersView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var orders: [Order] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                if orders.isEmpty {
                    OrdersEmptyStateView()
                        .padding(.top, 100)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(orders) { order in
                            OrderCardView(order: order)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .background(Color.white)
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - OrdersEmptyStateView
private struct OrdersEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bag")
                .font(.system(size: 60, weight: .ultraLight))
                .foregroundColor(Color(.systemGray3))
            
            VStack(spacing: 12) {
                Text("No Orders Yet")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Start exploring delicious homemade meals\nfrom local chefs in your area")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button(action: {
                // Navigate to home
            }) {
                Text("Explore Meals")
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

// MARK: - Order Model
struct Order: Identifiable {
    let id = UUID()
    let dishName: String
    let chefName: String
    let price: Double
    let orderDate: Date
    let status: OrderStatus
}

enum OrderStatus: String {
    case pending = "Pending"
    case preparing = "Preparing"
    case ready = "Ready for Pickup"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

// MARK: - OrderCardView
private struct OrderCardView: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 12) {
            // Dish Image Placeholder
            Rectangle()
                .fill(Color(.systemGray6))
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    Image(systemName: "fork.knife")
                        .font(.system(size: 24, weight: .ultraLight))
                        .foregroundColor(Color(.systemGray4))
                )
            
            // Order Details
            VStack(alignment: .leading, spacing: 6) {
                Text(order.dishName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text("by \(order.chefName)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Text("$\(String(format: "%.2f", order.price))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(statusColor(for: order.status))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(statusTextColor(for: order.status))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
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
    
    private func statusColor(for status: OrderStatus) -> String {
        return status.rawValue
    }
    
    private func statusTextColor(for status: OrderStatus) -> Color {
        switch status {
        case .pending: return Color(.systemGray)
        case .preparing: return Color.orange
        case .ready: return Color.green
        case .completed: return Color.black
        case .cancelled: return Color.red
        }
    }
}

// MARK: - Preview
#Preview {
    OrdersView()
}

