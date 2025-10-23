//
//  MessagesView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI


// MARK: - MessagesView
struct MessagesView: View {
    @State private var conversations: [Conversation] = sampleConversations
    @State private var searchText = ""
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations
        }
        return conversations.filter { conversation in
            conversation.chefName.localizedCaseInsensitiveContains(searchText) ||
            conversation.lastMessage.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Messages")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    // Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                        
                        TextField("Search conversations", text: $searchText)
                            .font(.system(size: 16, weight: .regular))
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
                .background(Color.white)
                
                Divider()
                
                // Conversations List
                if filteredConversations.isEmpty {
                    EmptyMessagesView(hasSearch: !searchText.isEmpty)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredConversations) { conversation in
                                NavigationLink(destination: MessageDetailView(
                                    chefName: conversation.chefName,
                                    chefAvatar: conversation.chefAvatar,
                                    dishName: nil
                                )) {
                                    MessageConversationRowContent(conversation: conversation)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if conversation.id != filteredConversations.last?.id {
                                    Divider()
                                        .padding(.leading, 82)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - MessageConversationRowContent
private struct MessageConversationRowContent: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(Color(.systemGray6))
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(Color(.systemGray4))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(conversation.chefName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(timeAgo(from: conversation.timestamp))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(conversation.lastMessage)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryColor)
                                .frame(width: 20, height: 20)
                            
                            Text("\(conversation.unreadCount)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private func timeAgo(from date: Date) -> String {
        let now = Date()
        let seconds = now.timeIntervalSince(date)
        
        if seconds < 60 {
            return "now"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            return "\(minutes)m"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            return "\(hours)h"
        } else if seconds < 604800 {
            let days = Int(seconds / 86400)
            return "\(days)d"
        } else {
            let weeks = Int(seconds / 604800)
            return "\(weeks)w"
        }
    }
}

// MARK: - EmptyMessagesView
private struct EmptyMessagesView: View {
    let hasSearch: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasSearch ? "magnifyingglass" : "message")
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundColor(Color(.systemGray3))
            
            Text(hasSearch ? "No results found" : "No messages yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Text(hasSearch ? "Try a different search term" : "Start messaging chefs about their dishes")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

// MARK: - Preview
#Preview {
    MessagesView()
}

