//
//  MessageDetailView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI


// MARK: - MessageDetailView
struct MessageDetailView: View {
    let chefName: String
    let chefAvatar: String?
    let dishName: String?
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessageItem] = []
    @State private var showingChefProfile = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Context Header (if from a dish)
                        if let dishName = dishName {
                            ContextHeaderView(dishName: dishName)
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                        }
                        
                        // Messages with date separators
                        ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                            // Show date separator if this is the first message or if the date changed
                            if index == 0 || !Calendar.current.isDate(message.timestamp, inSameDayAs: messages[index - 1].timestamp) {
                                DateSeparatorView(date: message.timestamp)
                                    .padding(.vertical, 8)
                            }
                            
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, dishName == nil ? 16 : 0)
                    .padding(.bottom, 20)
                }
                .background(Color.white)
                .onChange(of: messages.count) { oldValue, newValue in
                    if newValue > oldValue, let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Message Input Bar
            MessageInputBar(
                messageText: $messageText,
                onSend: sendMessage
            )
        }
        .navigationTitle(chefName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingChefProfile = true
                }) {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(Color(.systemGray4))
                        )
                }
            }
        }
        .sheet(isPresented: $showingChefProfile) {
            ChefProfileDetailView(chefName: chefName, chefAvatar: chefAvatar ?? "")
        }
        .onAppear {
            loadMessages()
        }
    }
    
    private func loadMessages() {
        // Load existing messages - create a realistic conversation
        if dishName != nil {
            // Conversation from product detail page
            messages = [
                ChatMessageItem(
                    text: "Hi! I'm interested in your \(dishName ?? "dish"). Is it still available?",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-7200),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "Hi there! Yes, it's available! I'm so glad you're interested. 😊",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-7000)
                ),
                ChatMessageItem(
                    text: "That's great! Can you tell me more about the ingredients? I have some dietary restrictions.",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-6800),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "Of course! I use fresh, locally sourced ingredients. What dietary restrictions do you have? I'm happy to accommodate.",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-6600)
                ),
                ChatMessageItem(
                    text: "I'm lactose intolerant. Can you make it without dairy?",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-6400),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "Absolutely! I can substitute with plant-based alternatives that taste just as good. The flavor won't be compromised at all.",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-6200)
                ),
                ChatMessageItem(
                    text: "Perfect! When would be the earliest I could pick it up?",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-6000),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "I can have it ready for you tomorrow evening around 6 PM. Does that work for you?",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-5800)
                ),
                ChatMessageItem(
                    text: "That works perfectly! How should we handle payment?",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-5600),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "You can pay with cash, Venmo, or Zelle when you pick it up. Whatever is most convenient for you!",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-5400)
                ),
                ChatMessageItem(
                    text: "Great! I'll bring cash. See you tomorrow at 6 PM! 👍",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-5200),
                    isDelivered: true,
                    isRead: false
                )
            ]
        } else {
            // Conversation from messages tab (existing conversation)
            messages = [
                ChatMessageItem(
                    text: "Hi! I saw your pasta carbonara listing. Is it still available?",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-86400),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "Hello! Yes, I can make it for you. When would you like to pick it up?",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-86200)
                ),
                ChatMessageItem(
                    text: "Tomorrow evening would be perfect. Around 7 PM?",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-86000),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "7 PM works great! I'll have it fresh and ready for you. My address is 123 Main St.",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-85800)
                ),
                ChatMessageItem(
                    text: "Perfect! Looking forward to trying it. Thanks!",
                    isFromUser: true,
                    timestamp: Date().addingTimeInterval(-85600),
                    isDelivered: true,
                    isRead: true
                ),
                ChatMessageItem(
                    text: "You're welcome! See you tomorrow! 😊",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-85400)
                )
            ]
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = ChatMessageItem(
            text: messageText,
            isFromUser: true,
            timestamp: Date(),
            isDelivered: false,
            isRead: false
        )
        
        messages.append(newMessage)
        let currentMessage = messageText.lowercased()
        messageText = ""
        
        // Mark as delivered after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let index = messages.firstIndex(where: { $0.id == newMessage.id }) {
                messages[index].isDelivered = true
            }
        }
        
        // Simulate contextual chef reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var replyText = "Thanks for your message! I'll get back to you shortly."
            
            // Context-aware replies
            if currentMessage.contains("available") || currentMessage.contains("still have") {
                replyText = "Yes, it's available! I can prepare it for you anytime."
            } else if currentMessage.contains("when") || currentMessage.contains("time") || currentMessage.contains("pickup") {
                replyText = "I'm flexible with timing. What works best for you? I'm usually available between 5-9 PM."
            } else if currentMessage.contains("price") || currentMessage.contains("cost") || currentMessage.contains("payment") {
                replyText = "The price is as listed. I accept cash, Venmo, or Zelle. Whatever is most convenient for you!"
            } else if currentMessage.contains("ingredient") || currentMessage.contains("allergy") || currentMessage.contains("dietary") {
                replyText = "I use fresh, high-quality ingredients. I'm happy to accommodate any dietary restrictions or allergies. Just let me know what you need!"
            } else if currentMessage.contains("thanks") || currentMessage.contains("thank you") || currentMessage.contains("great") {
                replyText = "You're very welcome! Looking forward to serving you! 😊"
            } else if currentMessage.contains("address") || currentMessage.contains("where") || currentMessage.contains("location") {
                replyText = "I'll send you my address once we confirm the pickup time. I'm in a safe, easy-to-find location."
            }
            
            let reply = ChatMessageItem(
                text: replyText,
                isFromUser: false,
                timestamp: Date()
            )
            messages.append(reply)
            
            // Mark user's message as read
            if let index = messages.firstIndex(where: { $0.id == newMessage.id }) {
                messages[index].isRead = true
            }
        }
    }
}

// MARK: - DateSeparatorView
private struct DateSeparatorView: View {
    let date: Date
    
    private var dateText: String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Day of week
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
            
            Text(dateText)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
            
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
        }
    }
}

// MARK: - ContextHeaderView
private struct ContextHeaderView: View {
    let dishName: String
    
    var body: some View {
        VStack(spacing: 8) {
            // Dish Context Card
            HStack(spacing: 12) {
                // Dish Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.primaryColor)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "fork.knife")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Discussing")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(dishName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            
            // Helper Text
            Text("Feel free to ask about ingredients, pickup time, and payment options")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
        }
        .padding(.bottom, 12)
    }
}

// MARK: - MessageBubbleView
private struct MessageBubbleView: View {
    let message: ChatMessageItem
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer(minLength: 60)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(AppColors.primaryColor)
                        .clipShape(MessageBubbleShape(isFromUser: true))
                    
                    HStack(spacing: 4) {
                        if message.isDelivered {
                            Image(systemName: message.isRead ? "checkmark.circle.fill" : "checkmark.circle")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(message.timestamp, style: .time)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .clipShape(MessageBubbleShape(isFromUser: false))
                    
                    Text(message.timestamp, style: .time)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 60)
            }
        }
    }
}

// MARK: - MessageBubbleShape
private struct MessageBubbleShape: Shape {
    let isFromUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight],
            cornerRadii: CGSize(width: 18, height: 18)
        )
        return Path(path.cgPath)
    }
}

// MARK: - MessageInputBar
private struct MessageInputBar: View {
    @Binding var messageText: String
    let onSend: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Text Input
            HStack(spacing: 8) {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .font(.system(size: 15, weight: .regular))
                    .focused($isTextFieldFocused)
                    .lineLimit(1...6)
                    .padding(.vertical, 10)
                    .padding(.leading, 14)
                
                // Attachment button (optional)
                Button(action: {
                    // Add attachment
                }) {
                    Image(systemName: "photo")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.trailing, 10)
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Send Button
            Button(action: {
                onSend()
                isTextFieldFocused = false
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32, weight: .regular))
                    .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color(.systemGray3) : AppColors.primaryColor)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

// MARK: - ChefProfileDetailView
private struct ChefProfileDetailView: View {
    let chefName: String
    let chefAvatar: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Chef Avatar
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40, weight: .light))
                                .foregroundColor(Color(.systemGray4))
                        )
                        .padding(.top, 20)
                    
                    // Chef Info
                    VStack(spacing: 8) {
                        Text(chefName)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Home Chef")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    
                    // Stats
                    HStack(spacing: 40) {
                        StatColumn(value: "4.9", label: "Rating")
                        StatColumn(value: "245", label: "Dishes")
                        StatColumn(value: "0.3 mi", label: "Distance")
                    }
                    .padding(.top, 8)
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Passionate home chef specializing in Italian and Mediterranean cuisine. I love creating authentic dishes using fresh, local ingredients.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .navigationTitle("Chef Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryColor)
                }
            }
        }
    }
}

// MARK: - StatColumn
private struct StatColumn: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
            
            Text(label)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - ChatMessageItem
struct ChatMessageItem: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
    var isDelivered: Bool = true
    var isRead: Bool = false
    
    static func == (lhs: ChatMessageItem, rhs: ChatMessageItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        MessageDetailView(
            chefName: "Maria Garcia",
            chefAvatar: nil,
            dishName: "Homemade Pasta Carbonara"
        )
    }
}

