//
//  TabViewComponents.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI
import MapKit

// MARK: - Color Theme
struct AppColors {
    // 60-30-10 Color Rule
    static let primaryColor = Color(red: 255/255, green: 30/255, blue: 0/255) // #FF1E00 - Primary accent - 10%
    static let secondaryColor = Color.black // Secondary color - 30%
    static let neutralColor = Color.white // Neutral background - 60%
    static let neutralAccent = Color(.systemGray6) // Neutral accent for backgrounds
}


// MARK: - ExploreView
struct ExploreView: View {
    @State private var searchText = ""
    @State private var currentPostIndex = 0
    @State private var showingCommunityChat = false
    @State private var showingDMs = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main TikTok-style feed
                TikTokStyleFeed(currentPostIndex: $currentPostIndex)
                
                // Top search bar and chat button
                VStack {
                    HStack {
                        SearchBarView(searchText: $searchText)
                            .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            showingDMs = true
                        }) {
                            Image(systemName: "message.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50) // Account for safe area
                    
                    Spacer()
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingCommunityChat) {
            CommunityChatView()
        }
        .sheet(isPresented: $showingDMs) {
            DirectMessagesView()
        }
    }
}

// MARK: - TikTokStyleFeed
struct TikTokStyleFeed: View {
    @Binding var currentPostIndex: Int
    @State private var posts: [TikTokPost] = sampleTikTokPosts
    
    var body: some View {
        GeometryReader { geometry in
            if posts.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 60, weight: .ultraLight))
                        .foregroundColor(Color(.systemGray3))
                    
                    VStack(spacing: 12) {
                        Text("No Dishes Yet")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Be the first to discover amazing\nhomemade meals in your area")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    
                    Button(action: {
                        // Refresh or explore
                    }) {
                        Text("Refresh Feed")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(AppColors.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 8)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.white)
            } else {
                TabView(selection: $currentPostIndex) {
                    ForEach(Array(posts.enumerated()), id: \.offset) { index, post in
                        TikTokPostView(post: post, index: index)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .background(Color.white)
            }
        }
    }
}

// MARK: - TikTokPostView
struct TikTokPostView: View {
    let post: TikTokPost
    let index: Int
    @State private var isLiked = false
    @State private var likeCount: Int
    @State private var showingChat = false
    @State private var showingShareSheet = false
    @State private var showingChefProfile = false
    
    init(post: TikTokPost, index: Int) {
        self.post = post
        self.index = index
        self._likeCount = State(initialValue: post.likeCount)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image/video
                AsyncImage(url: URL(string: post.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "photo")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Loading...")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        )
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.3),
                        Color.clear,
                        Color.black.opacity(0.5)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Content Container
                VStack {
                    Spacer()
                    
                    HStack {
                        // Left side - Post info
                        VStack(alignment: .leading, spacing: 16) {
                            // Chef info
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: post.chefAvatar)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Circle()
                                        .fill(Color.gray.opacity(0.5))
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 20, weight: .light))
                                                .foregroundColor(.white.opacity(0.6))
                                        )
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(post.chefName)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(post.dishName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .onTapGesture {
                                    showingChefProfile = true
                                }
                            }
                            
                            // Description
                            Text(post.description)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                            
                            // Price and distance
                            HStack(spacing: 16) {
                                Text("$\(String(format: "%.2f", post.price))")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("• \(post.distance)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        // Right side - Action buttons
                        VStack(spacing: 24) {
                            // Like button
                            VStack(spacing: 8) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isLiked.toggle()
                                        likeCount += isLiked ? 1 : -1
                                    }
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                            .font(.system(size: 32, weight: .medium))
                                            .foregroundColor(isLiked ? .red : .white)
                                            .scaleEffect(isLiked ? 1.2 : 1.0)
                                        
                                        Text("\(likeCount)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            
                            // Community Chat button
                            VStack(spacing: 8) {
                                Button(action: {
                                    showingChat = true
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "bubble.left.and.bubble.right")
                                            .font(.system(size: 32, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Text("Community")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            

                            
                            // Share button
                            VStack(spacing: 8) {
                                Button(action: {
                                    showingShareSheet = true
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 32, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Text("Share")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Account for safe area and tab bar
                }
            }
        }
        .sheet(isPresented: $showingChat) {
            CommunityChatView()
        }
        .sheet(isPresented: $showingChefProfile) {
            ChefProfileView(chef: post.chefName, chefAvatar: post.chefAvatar)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheetView(post: post)
        }
    }
}

// MARK: - SearchBarView
private struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField("Search dishes, chefs, cuisines...", text: $searchText)
                .font(.system(size: 16, weight: .medium))
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}







// MARK: - TikTok Post Data Models
struct TikTokPost: Identifiable {
    let id = UUID()
    let chefName: String
    let chefAvatar: String
    let dishName: String
    let description: String
    let price: Double
    let distance: String
    let imageURL: String
    let likeCount: Int
    let commentCount: Int
    let shareCount: Int
}

// MARK: - Chat Detail View
struct ChatDetailView: View {
    let chef: String
    let dish: String
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat messages
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            ChatMessageView(message: message)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // Message input
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
            }
            .navigationTitle("Chat with \(chef)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = ChatMessage(
            text: messageText,
            isFromUser: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messageText = ""
        
        // Simulate reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let reply = ChatMessage(
                text: "Thanks for your message! I'll get back to you soon about the \(dish).",
                isFromUser: false,
                timestamp: Date()
            )
            messages.append(reply)
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Spacer()
            }
        }
    }
}

// MARK: - Sample TikTok Posts
let sampleTikTokPosts = [
    TikTokPost(
        chefName: "Maria Garcia",
        chefAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop",
        dishName: "Homemade Pasta Carbonara",
        description: "Fresh fettuccine with creamy carbonara sauce, pancetta, and parmesan cheese. Made with love in my home kitchen! 🍝✨",
        price: 18.99,
        distance: "0.3 miles away",
        imageURL: "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=600&h=800&fit=crop",
        likeCount: 1247,
        commentCount: 89,
        shareCount: 23
    ),
    TikTokPost(
        chefName: "Tony Chen",
        chefAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop",
        dishName: "Spicy Thai Curry",
        description: "Authentic red curry with coconut milk, vegetables, and your choice of chicken or tofu. Served with jasmine rice! 🌶️🍛",
        price: 15.50,
        distance: "0.7 miles away",
        imageURL: "https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=600&h=800&fit=crop",
        likeCount: 892,
        commentCount: 67,
        shareCount: 15
    ),
    TikTokPost(
        chefName: "Sophie Martin",
        chefAvatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop",
        dishName: "Coq au Vin",
        description: "Classic French braised chicken with wine, mushrooms, and pearl onions. A taste of Paris in every bite! 🇫🇷🍷",
        price: 22.00,
        distance: "1.2 miles away",
        imageURL: "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=600&h=800&fit=crop",
        likeCount: 1567,
        commentCount: 134,
        shareCount: 45
    ),
    TikTokPost(
        chefName: "Ahmed Hassan",
        chefAvatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop",
        dishName: "Shawarma Plate",
        description: "Authentic Middle Eastern shawarma with tender chicken, fresh vegetables, and homemade hummus. Street food perfection! 🥙✨",
        price: 16.99,
        distance: "0.5 miles away",
        imageURL: "https://images.unsplash.com/photo-1529042410759-befb1204b468?w=600&h=800&fit=crop",
        likeCount: 2034,
        commentCount: 156,
        shareCount: 78
    ),
    TikTokPost(
        chefName: "Sarah Johnson",
        chefAvatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop",
        dishName: "Margherita Pizza",
        description: "Wood-fired pizza with fresh mozzarella, basil, and San Marzano tomatoes. Crispy crust, gooey cheese! 🍕🔥",
        price: 19.99,
        distance: "0.8 miles away",
        imageURL: "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&h=800&fit=crop",
        likeCount: 1789,
        commentCount: 98,
        shareCount: 34
    )
]

// MARK: - AddDishView
struct AddDishView: View {
    let userLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var cuisine = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isSubmitting = false
    @State private var hostVerificationStatus: HostVerificationStatus = .notApplied // Change this based on actual user status
    @State private var showingBecomeHost = false
    
    var body: some View {
        NavigationView {
            if hostVerificationStatus == .approved {
                VerifiedAddDishView(
                    userLocation: userLocation,
                    title: $title,
                    description: $description,
                    price: $price,
                    cuisine: $cuisine,
                    selectedImages: $selectedImages,
                    showingImagePicker: $showingImagePicker,
                    showingActionSheet: $showingActionSheet,
                    sourceType: $sourceType,
                    isSubmitting: $isSubmitting,
                    onDismiss: { dismiss() },
                    onSubmit: submitAd
                )
            } else {
                UnverifiedAddDishView(
                    status: hostVerificationStatus,
                    showingBecomeHost: $showingBecomeHost
                )
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Add Photos"),
                buttons: [
                    .default(Text("Camera")) {
                        sourceType = .camera
                        showingImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        sourceType = .photoLibrary
                        showingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImages: $selectedImages, sourceType: sourceType)
        }
        .sheet(isPresented: $showingBecomeHost) {
            BecomeHostView()
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !description.isEmpty && !price.isEmpty && !cuisine.isEmpty && !selectedImages.isEmpty && hostVerificationStatus == .approved
    }
    
    private func submitAd() {
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false
            // Reset form
            title = ""
            description = ""
            price = ""
            cuisine = ""
            selectedImages = []
            dismiss()
        }
    }
}

// MARK: - UnverifiedAddDishView
struct UnverifiedAddDishView: View {
    let status: HostVerificationStatus
    @Binding var showingBecomeHost: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                        .frame(height: 8)
                }
                
                // Status-specific content
                switch status {
                case .notApplied:
                    NotAppliedView(showingBecomeHost: $showingBecomeHost)
                case .applying:
                    ApplyingView()
                case .pending:
                    PendingView()
                case .rejected:
                    RejectedView(showingBecomeHost: $showingBecomeHost)
                case .approved:
                    EmptyView() // This shouldn't happen in this view
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}

// MARK: - NotAppliedView
private struct NotAppliedView: View {
    @Binding var showingBecomeHost: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            // Hero Section
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Become a Verified Host")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Join our community of home chefs and share your delicious homemade meals with food lovers in your area.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .padding(.horizontal, 20)
            
            // Benefits Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Why become a host?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    BenefitCard(
                        icon: "dollarsign.circle.fill",
                        title: "Earn Money",
                        description: "Turn your passion into profit by sharing your cooking skills"
                    )
                    
                    BenefitCard(
                        icon: "calendar.badge.clock",
                        title: "Flexible Schedule",
                        description: "Set your own hours and cook when it works for you"
                    )
                    
                    BenefitCard(
                        icon: "person.3.fill",
                        title: "Build Community",
                        description: "Connect with food lovers and build lasting relationships"
                    )
                    
                    BenefitCard(
                        icon: "shield.fill",
                        title: "Safe & Secure",
                        description: "Our verification process ensures quality and safety"
                    )
                }
                .padding(.horizontal, 20)
            }
            
            // CTA Section
            VStack(spacing: 16) {
                Button(action: {
                    showingBecomeHost = true
                }) {
                    HStack(spacing: 8) {
                        Text("Apply to Become a Host")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.primaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Text("Application takes 5-10 minutes")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - ApplyingView
private struct ApplyingView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundColor(.blue)
                }
                
                VStack(spacing: 12) {
                    Text("Submitting Application")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Please wait while we process your application...")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 20)
            
            // Progress indicator
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.2)
                
                Text("This may take a few moments")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - PendingView
private struct PendingView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "hourglass")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundColor(.orange)
                }
                
                VStack(spacing: 12) {
                    Text("Application Under Review")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("We're reviewing your application and will notify you via email once it's complete.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .padding(.horizontal, 20)
            
            // Timeline
            VStack(alignment: .leading, spacing: 20) {
                Text("What happens next?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    TimelineStep(
                        number: "1",
                        title: "Application Review",
                        description: "We review your application and kitchen photos",
                        isCompleted: true
                    )
                    
                    TimelineStep(
                        number: "2",
                        title: "Background Check",
                        description: "Safety verification is conducted",
                        isCompleted: false
                    )
                    
                    TimelineStep(
                        number: "3",
                        title: "Final Approval",
                        description: "You'll receive an email with the decision",
                        isCompleted: false
                    )
                }
                .padding(.horizontal, 20)
            }
            
            // Timeline info
            VStack(spacing: 8) {
                Text("Typical review time: 2-3 business days")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text("We'll notify you as soon as your application is approved!")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - RejectedView
private struct RejectedView: View {
    @Binding var showingBecomeHost: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundColor(.red)
                }
                
                VStack(spacing: 12) {
                    Text("Application Not Approved")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("We couldn't approve your application at this time. Please review the requirements and try again.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .padding(.horizontal, 20)
            
            // Common reasons
            VStack(alignment: .leading, spacing: 20) {
                Text("Common reasons for rejection:")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    RejectionReason(text: "Incomplete application information")
                    RejectionReason(text: "Kitchen photos don't meet requirements")
                    RejectionReason(text: "Missing required certifications")
                    RejectionReason(text: "Background check issues")
                }
                .padding(.horizontal, 20)
            }
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    showingBecomeHost = true
                }) {
                    Text("Reapply")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppColors.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button(action: {
                    // Contact support action
                }) {
                    Text("Contact Support")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - VerifiedAddDishView
struct VerifiedAddDishView: View {
    let userLocation: CLLocationCoordinate2D?
    @Binding var title: String
    @Binding var description: String
    @Binding var price: String
    @Binding var cuisine: String
    @Binding var selectedImages: [UIImage]
    @Binding var showingImagePicker: Bool
    @Binding var showingActionSheet: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var isSubmitting: Bool
    let onDismiss: () -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Button("Cancel") {
                            onDismiss()
                        }
                        .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add a dish")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Share your homemade meals with the community")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Image Upload Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Photos")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    if selectedImages.isEmpty {
                        Button(action: {
                            showingActionSheet = true
                        }) {
                            VStack(spacing: 16) {
                                Image(systemName: "photo")
                                    .font(.system(size: 36, weight: .ultraLight))
                                    .foregroundColor(Color(.systemGray3))
                                
                                Text("Add photos")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("Up to 5 photos")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                            )
                        }
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<selectedImages.count, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: selectedImages[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                        
                                        Button(action: {
                                            selectedImages.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .background(AppColors.primaryColor.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .padding(8)
                                    }
                                }
                                
                                if selectedImages.count < 5 {
                                    Button(action: {
                                        showingActionSheet = true
                                    }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 20, weight: .regular))
                                                .foregroundColor(.secondary)
                                            
                                            Text("Add more")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(width: 120, height: 120)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(.systemGray5), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Form Fields
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dish name")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Homemade Pasta Carbonara", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, weight: .regular))
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Describe your dish, ingredients, cooking method...", text: $description, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, weight: .regular))
                            .lineLimit(4...6)
                    }
                    
                    // Price
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Price per serving")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 8) {
                            Text("$")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("0.00", text: $price)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, weight: .regular))
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    // Cuisine
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cuisine type")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Italian, Thai, Mexican...", text: $cuisine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, weight: .regular))
                    }
                }
                .padding(.horizontal, 20)
                
                // Submit Button
                VStack(spacing: 12) {
                    Button(action: onSubmit) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Post dish")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(isFormValid ? AppColors.primaryColor : Color(.systemGray3))
                        .cornerRadius(12)
                    }
                    .disabled(!isFormValid || isSubmitting)
                    
                    Text("By posting, you agree to our community guidelines")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !description.isEmpty && !price.isEmpty && !cuisine.isEmpty && !selectedImages.isEmpty
    }
}

// MARK: - Supporting Views

struct BenefitCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(AppColors.primaryColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

struct TimelineStep: View {
    let number: String
    let title: String
    let description: String
    let isCompleted: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(isCompleted ? AppColors.primaryColor : Color(.systemGray5))
                    .frame(width: 32, height: 32)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Text(number)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

struct RejectionReason: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 6, height: 6)
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - VerificationBannerView
private struct VerificationBannerView: View {
    let status: HostVerificationStatus
    @Binding var showingBecomeHost: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: bannerIcon)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(bannerColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bannerTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(bannerMessage)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if status == .notApplied {
                Button(action: {
                    showingBecomeHost = true
                }) {
                    Text("Apply")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(16)
        .background(bannerBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(bannerBorder, lineWidth: 1)
        )
    }
    
    private var bannerIcon: String {
        switch status {
        case .notApplied: return "exclamationmark.circle"
        case .applying: return "paperplane.circle"
        case .pending: return "hourglass"
        case .approved: return "checkmark.circle"
        case .rejected: return "xmark.circle"
        }
    }
    
    private var bannerTitle: String {
        switch status {
        case .notApplied: return "Host Verification Required"
        case .applying: return "Submitting Application"
        case .pending: return "Verification Pending"
        case .approved: return "Verified Host"
        case .rejected: return "Verification Not Approved"
        }
    }
    
    private var bannerMessage: String {
        switch status {
        case .notApplied: return "Apply to become a verified host to start posting"
        case .applying: return "Sending your application..."
        case .pending: return "We're reviewing your application"
        case .approved: return "You can now post dishes"
        case .rejected: return "Please reapply or contact support"
        }
    }
    
    private var bannerColor: Color {
        switch status {
        case .notApplied: return AppColors.primaryColor
        case .applying: return .blue
        case .pending: return .orange
        case .approved: return .green
        case .rejected: return .red
        }
    }
    
    private var bannerBackground: Color {
        switch status {
        case .notApplied: return Color(.systemGray6)
        case .applying: return Color.blue.opacity(0.1)
        case .pending: return Color.orange.opacity(0.1)
        case .approved: return Color.green.opacity(0.1)
        case .rejected: return Color.red.opacity(0.1)
        }
    }
    
    private var bannerBorder: Color {
        switch status {
        case .notApplied: return Color(.systemGray5)
        case .applying: return Color.blue.opacity(0.3)
        case .pending: return Color.orange.opacity(0.3)
        case .approved: return Color.green.opacity(0.3)
        case .rejected: return Color.red.opacity(0.3)
        }
    }
}

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImages.append(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}



// MARK: - TabButton
private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryColor : AppColors.secondaryColor.opacity(0.6))
                
                Rectangle()
                    .fill(isSelected ? AppColors.primaryColor : Color.clear)
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)
    }
}











// MARK: - ProfileView
struct ProfileView: View {
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Profile Header
                    ProfileHeaderView(showingEditProfile: $showingEditProfile, showingImagePicker: $showingImagePicker)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                    
                    // Stats Section
                    StatsView()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    
                    // Quick Actions
                    QuickActionsView()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    
                    
                    // Menu Section
                    MenuSectionView(showingSettings: $showingSettings)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                }
            }
            .background(AppColors.neutralColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImages: .constant([]), sourceType: .photoLibrary)
            }
        }
    }
}

// MARK: - ProfileHeaderView
private struct ProfileHeaderView: View {
    @Binding var showingEditProfile: Bool
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image with Edit Button
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(AppColors.neutralColor)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(AppColors.secondaryColor.opacity(0.3))
                    )
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Circle()
                        .fill(AppColors.primaryColor)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppColors.neutralColor)
                        )
                }
            }
            
            // User Info
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Text("John Doe")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                }
                
                Text("john.doe@example.com")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12, weight: .regular))
                    Text("San Francisco, CA")
                        .font(.system(size: 14, weight: .regular))
                }
                .foregroundColor(.secondary)
                .padding(.top, 2)
            }
            
            // Member Since
            Text("Member since January 2024")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
            
            // Edit Profile Button
            Button(action: {
                showingEditProfile = true
            }) {
                Text("Edit Profile")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - StatsView
private struct StatsView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                StatItemView(title: "Orders", value: "12")
                Divider()
                    .frame(height: 60)
                StatItemView(title: "Reviews", value: "8")
                Divider()
                    .frame(height: 60)
                StatItemView(title: "Favorites", value: "24")
            }
            .padding(.vertical, 16)
        }
        .background(AppColors.neutralColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.secondaryColor.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - StatItemView
private struct StatItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        Button(action: {
            // Navigate to detailed view
        }) {
            VStack(spacing: 8) {
                Text(value)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                
                Text(title)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - QuickActionsView
private struct QuickActionsView: View {
    @State private var showingBecomeHost = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.secondaryColor)
            
            HStack(spacing: 12) {
                QuickActionCard(
                    title: "Become a Host"
                ) {
                    showingBecomeHost = true
                }
                
                QuickActionCard(
                    title: "Invite Friends"
                ) {
                    // Handle action
                }
            }
        }
        .sheet(isPresented: $showingBecomeHost) {
            BecomeHostView()
        }
    }
}

// MARK: - QuickActionCard
private struct QuickActionCard: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(AppColors.neutralColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.secondaryColor.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - RecentActivityView
private struct RecentActivityView: View {
    @State private var activities: [ActivityItem] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Activity")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if !activities.isEmpty {
                    Button(action: {
                        // View all activity
                    }) {
                        Text("See All")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
            }
            
            if activities.isEmpty {
                EmptyStateView(
                    icon: "clock",
                    title: "No Activity Yet",
                    message: "Your recent orders, favorites, and reviews will appear here"
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                        ActivityRowView(
                            icon: activity.icon,
                            title: activity.title,
                            subtitle: activity.subtitle,
                            time: activity.time
                        )
                        
                        if index < activities.count - 1 {
                            Divider()
                                .padding(.leading, 52)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
            }
        }
        .onAppear {
            loadActivities()
        }
    }
    
    private func loadActivities() {
        // Simulate loading - set to empty array to show empty state
        // Or populate with real data
        activities = [
            ActivityItem(icon: "bag.fill", title: "Order Completed", subtitle: "Homemade Pasta Carbonara", time: "2 hours ago"),
            ActivityItem(icon: "heart.fill", title: "Added to Favorites", subtitle: "Spicy Thai Curry", time: "Yesterday"),
            ActivityItem(icon: "star.fill", title: "Left a Review", subtitle: "Coq au Vin - 5 stars", time: "2 days ago")
        ]
    }
}

// MARK: - EmptyStateView
private struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundColor(Color(.systemGray3))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .padding(.horizontal, 32)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - ActivityItem
private struct ActivityItem {
    let icon: String
    let title: String
    let subtitle: String
    let time: String
}

// MARK: - ActivityRowView
private struct ActivityRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(time)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.secondary)
        }
        .padding(12)
    }
}

// MARK: - MenuSectionView
private struct MenuSectionView: View {
    @Binding var showingSettings: Bool
    @State private var showingOrders = false
    @State private var showingFavorites = false
    @State private var showingLegal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Account Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Account")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                
                VStack(spacing: 0) {
                    Button(action: {
                        showingOrders = true
                    }) {
                        MenuRowContent(
                            title: "My Orders",
                            subtitle: "View order history"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    Button(action: {
                        showingFavorites = true
                    }) {
                        MenuRowContent(
                            title: "Favorites",
                            subtitle: "Saved dishes"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Payment Methods",
                        subtitle: "Manage payments",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Help & Support",
                        subtitle: "Get assistance",
                        action: {}
                    )
                }
            }
            
            // Legal Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Legal & Privacy")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                
                VStack(spacing: 0) {
                    Button(action: {
                        showingLegal = true
                    }) {
                        MenuRowContent(
                            title: "Legal Information",
                            subtitle: "Terms, Privacy, and Policies",
                            icon: "doc.text.fill"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Terms of Service",
                        subtitle: "User agreement and conditions",
                        icon: "doc.plaintext.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Privacy Policy",
                        subtitle: "How we collect and use your data",
                        icon: "hand.raised.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Cookie Policy",
                        subtitle: "How we use cookies and tracking",
                        icon: "cookie.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Data Protection Rights",
                        subtitle: "Your rights under GDPR and CCPA",
                        icon: "shield.lefthalf.filled",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Community Guidelines",
                        subtitle: "Rules for using our platform",
                        icon: "person.3.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Food Safety Standards",
                        subtitle: "Health and safety requirements",
                        icon: "checkmark.shield.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Intellectual Property",
                        subtitle: "Copyright and trademark policies",
                        icon: "c.circle.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Dispute Resolution",
                        subtitle: "How we handle conflicts",
                        icon: "scale.3d",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Contact Legal Team",
                        subtitle: "Reach our legal department",
                        icon: "envelope.fill",
                        action: {}
                    )
                }
            }
            
            // About Section
            VStack(alignment: .leading, spacing: 16) {
                Text("About")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                
                VStack(spacing: 0) {
                    MenuRowView(
                        title: "App Version",
                        subtitle: "Version 1.0.0 (Build 1)",
                        icon: "info.circle.fill",
                        action: {}
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    MenuRowView(
                        title: "Open Source Licenses",
                        subtitle: "Third-party software licenses",
                        icon: "doc.text.magnifyingglass",
                        action: {}
                    )
                }
            }
        }
        .sheet(isPresented: $showingLegal) {
            LegalInformationView()
        }
        .sheet(isPresented: $showingOrders) {
            OrdersView()
        }
        .sheet(isPresented: $showingFavorites) {
            FavoritesView()
        }
    }
}

// MARK: - MenuRowContent
private struct MenuRowContent: View {
    let title: String
    let subtitle: String
    let icon: String?
    
    init(title: String, subtitle: String, icon: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(AppColors.primaryColor)
                    .frame(width: 24)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.secondaryColor)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppColors.secondaryColor.opacity(0.4))
        }
        .padding(14)
    }
}

// MARK: - MenuRowView
private struct MenuRowView: View {
    let title: String
    let subtitle: String
    let icon: String?
    let action: () -> Void
    
    init(title: String, subtitle: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(AppColors.primaryColor)
                        .frame(width: 24)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.secondaryColor)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.4))
            }
            .padding(14)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - LegalInformationView
struct LegalInformationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Legal Information")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Comprehensive legal documentation for Gruby platform")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Legal Sections
                    VStack(spacing: 24) {
                        LegalSectionCard(
                            title: "Terms of Service",
                            description: "User agreement, platform rules, and service conditions",
                            lastUpdated: "December 2024",
                            icon: "doc.plaintext.fill"
                        )
                        
                        LegalSectionCard(
                            title: "Privacy Policy",
                            description: "Data collection, usage, and protection practices",
                            lastUpdated: "December 2024",
                            icon: "hand.raised.fill"
                        )
                        
                        LegalSectionCard(
                            title: "Cookie Policy",
                            description: "Cookie usage, tracking, and user preferences",
                            lastUpdated: "December 2024",
                            icon: "cookie.fill"
                        )
                        
                        LegalSectionCard(
                            title: "Data Protection Rights",
                            description: "GDPR, CCPA, and user data rights information",
                            lastUpdated: "December 2024",
                            icon: "shield.lefthalf.filled"
                        )
                        
                        LegalSectionCard(
                            title: "Community Guidelines",
                            description: "Platform rules, conduct standards, and enforcement",
                            lastUpdated: "December 2024",
                            icon: "person.3.fill"
                        )
                        
                        LegalSectionCard(
                            title: "Food Safety Standards",
                            description: "Health regulations, safety requirements, and compliance",
                            lastUpdated: "December 2024",
                            icon: "checkmark.shield.fill"
                        )
                        
                        LegalSectionCard(
                            title: "Intellectual Property",
                            description: "Copyright, trademark, and content ownership policies",
                            lastUpdated: "December 2024",
                            icon: "c.circle.fill"
                        )
                        
                        LegalSectionCard(
                            title: "Dispute Resolution",
                            description: "Conflict resolution, arbitration, and legal procedures",
                            lastUpdated: "December 2024",
                            icon: "scale.3d"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Legal Contact")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ContactInfoRow(
                                icon: "envelope.fill",
                                title: "Legal Department",
                                subtitle: "legal@gruby.com"
                            )
                            
                            ContactInfoRow(
                                icon: "phone.fill",
                                title: "Legal Hotline",
                                subtitle: "+1 (555) 123-LEGAL"
                            )
                            
                            ContactInfoRow(
                                icon: "building.2.fill",
                                title: "Mailing Address",
                                subtitle: "Gruby Legal Department\n123 Food Street\nSan Francisco, CA 94102"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - LegalSectionCard
private struct LegalSectionCard: View {
    let title: String
    let description: String
    let lastUpdated: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(AppColors.primaryColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Last updated: \(lastUpdated)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Text(description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(2)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - ContactInfoRow
private struct ContactInfoRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(AppColors.primaryColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - EditProfileView
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var location = "San Francisco, CA"
    @State private var bio = "Food lover exploring local homemade cuisines"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Profile Photo Section
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40, weight: .light))
                                        .foregroundColor(Color(.systemGray3))
                                )
                            
                            Button(action: {
                                // Change photo
                            }) {
                                Circle()
                                    .fill(AppColors.primaryColor)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 20)
                    
                    // Personal Information
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Personal Information")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            FormFieldView(label: "Name", text: $name, placeholder: "Enter your name")
                            FormFieldView(label: "Email", text: $email, placeholder: "Enter your email")
                            FormFieldView(label: "Location", text: $location, placeholder: "Enter your location")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bio")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextEditor(text: $bio)
                                    .frame(height: 100)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(.systemGray5), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    
                    // Account Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Button(action: {
                            // Change password
                        }) {
                            HStack {
                                Text("Change Password")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            // Delete account
                        }) {
                            HStack {
                                Text("Delete Account")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.red)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.red)
                            }
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save changes
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - FormFieldView
private struct FormFieldView: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.black)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 15, weight: .regular))
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        }
    }
} 

// MARK: - SettingsView
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var darkModeEnabled = false
    @State private var biometricEnabled = true
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header Section
                    SettingsHeaderView()
                    
                    // Account Section
                    SettingsSectionView(title: "Account") {
                        SettingsRowView(
                            title: "Personal Information",
                            subtitle: "Name, email, phone"
                        ) {
                            // Navigate to personal info
                        }
                        
                        SettingsRowView(
                            title: "Payment Methods",
                            subtitle: "Cards, Apple Pay"
                        ) {
                            // Navigate to payment methods
                        }
                        
                        SettingsRowView(
                            title: "Addresses",
                            subtitle: "Delivery locations"
                        ) {
                            // Navigate to addresses
                        }
                    }
                    
                    // Preferences Section
                    SettingsSectionView(title: "Preferences") {
                        SettingsToggleRowView(
                            title: "Push Notifications",
                            subtitle: "Order updates, promotions",
                            isOn: $notificationsEnabled
                        )
                        
                        SettingsToggleRowView(
                            title: "Location Services",
                            subtitle: "Find nearby meals",
                            isOn: $locationEnabled
                        )
                        
                        SettingsToggleRowView(
                            title: "Dark Mode",
                            subtitle: "Use dark appearance",
                            isOn: $darkModeEnabled
                        )
                        
                        SettingsToggleRowView(
                            title: "Face ID / Touch ID",
                            subtitle: "Quick app access",
                            isOn: $biometricEnabled
                        )
                    }
                    
                    // Support Section
                    SettingsSectionView(title: "Support") {
                        SettingsRowView(
                            title: "Help Center",
                            subtitle: "FAQs and guides"
                        ) {
                            // Navigate to help center
                        }
                        
                        SettingsRowView(
                            title: "Contact Support",
                            subtitle: "Get in touch"
                        ) {
                            // Navigate to contact support
                        }
                        
                        SettingsRowView(
                            title: "Privacy Policy",
                            subtitle: "How we protect your data"
                        ) {
                            // Show privacy policy
                        }
                        
                        SettingsRowView(
                            title: "Terms of Service",
                            subtitle: "App usage terms"
                        ) {
                            // Show terms of service
                        }
                    }
                    
                    // Account Actions Section
                    SettingsSectionView(title: "Account") {
                        SettingsRowView(
                            title: "Sign Out",
                            subtitle: "Log out of your account"
                        ) {
                            showingLogoutAlert = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .background(AppColors.neutralColor)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                }
            }
            .alert("Sign Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    // Handle sign out
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

// MARK: - SettingsHeaderView
private struct SettingsHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // App Icon
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.primaryColor)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "fork.knife")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(AppColors.neutralColor)
            }
            
            // App Info
            VStack(spacing: 4) {
                Text("Gruby")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                
                Text("Version 1.0.0")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.6))
            }
        }
        .padding(.vertical, 20)
    }
}

// MARK: - SettingsSectionView
private struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.secondaryColor)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.neutralColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.secondaryColor.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

// MARK: - SettingsRowView
private struct SettingsRowView: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Text Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.secondaryColor)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - SettingsToggleRowView
private struct SettingsToggleRowView: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Text Content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.secondaryColor)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColors.secondaryColor.opacity(0.6))
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.primaryColor))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
} 



// MARK: - ChefProfileView
struct ChefProfileView: View {
    let chef: String
    let chefAvatar: String
    @Environment(\.dismiss) private var dismiss
    @State private var showingChat = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Chef Avatar
                    AsyncImage(url: URL(string: chefAvatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(red: 1.0, green: 0.12, blue: 0.0), lineWidth: 3))
                    
                    // Chef Info
                    VStack(spacing: 8) {
                        Text(chef)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Home Chef")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            VStack {
                                Text("4.8")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Rating")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                Text("127")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Orders")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                Text("2.1")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Miles")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 16)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            showingChat = true
                        }) {
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Message Chef")
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // Follow chef
                        }) {
                            HStack {
                                Image(systemName: "heart.fill")
                                Text("Follow Chef")
                            }
                            .foregroundColor(Color(red: 1.0, green: 0.12, blue: 0.0))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 1.0, green: 0.12, blue: 0.0).opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Chef Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingChat) {
                ChatDetailView(chef: chef, dish: "Chef's Kitchen")
            }
        }
    }
}

// MARK: - ShareSheetView
struct ShareSheetView: View {
    let post: TikTokPost
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Share Preview
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: post.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(spacing: 8) {
                        Text(post.dishName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        Text("by \(post.chefName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                
                // Share Options
                VStack(spacing: 16) {
                    ShareOptionButton(
                        title: "Copy Link",
                        icon: "link",
                        color: .blue
                    ) {
                        // Copy link functionality
                        dismiss()
                    }
                    
                    ShareOptionButton(
                        title: "Share to Social Media",
                        icon: "square.and.arrow.up",
                        color: .green
                    ) {
                        // Share to social media
                        dismiss()
                    }
                    
                    ShareOptionButton(
                        title: "Send to Friends",
                        icon: "message.fill",
                        color: .purple
                    ) {
                        // Send to friends
                        dismiss()
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Share Dish")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - ShareOptionButton
private struct ShareOptionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 

// MARK: - CommunityChatView
struct CommunityChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [CommunityMessage] = sampleCommunityMessages
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat messages
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            CommunityMessageView(message: message)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // Message input
                HStack(spacing: 12) {
                    TextField("Share something with the community...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
            }
            .navigationTitle("Community Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = CommunityMessage(
            text: messageText,
            username: "You",
            timestamp: Date(),
            isFromCurrentUser: true
        )
        
        messages.append(newMessage)
        messageText = ""
    }
}

// MARK: - DirectMessagesView
struct DirectMessagesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var conversations: [Conversation] = sampleConversations
    @State private var showingChat = false
    @State private var selectedConversation: Conversation?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(conversations) { conversation in
                    ConversationRowView(conversation: conversation) {
                        selectedConversation = conversation
                        showingChat = true
                    }
                }
            }
            .navigationTitle("Direct Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingChat) {
            if let conversation = selectedConversation {
                DirectMessageChatView(conversation: conversation)
            }
        }
    }
}

// MARK: - DirectMessageChatView
struct DirectMessageChatView: View {
    let conversation: Conversation
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [DirectMessage] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat messages
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            DirectMessageView(message: message)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // Message input
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
            }
            .navigationTitle(conversation.chefName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                messages = conversation.messages
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = DirectMessage(
            text: messageText,
            isFromUser: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messageText = ""
    }
}

// MARK: - Data Models
struct CommunityMessage: Identifiable {
    let id = UUID()
    let text: String
    let username: String
    let timestamp: Date
    let isFromCurrentUser: Bool
}

struct Conversation: Identifiable {
    let id = UUID()
    let chefName: String
    let chefAvatar: String
    let lastMessage: String
    let timestamp: Date
    let unreadCount: Int
    let messages: [DirectMessage]
}

struct DirectMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

// MARK: - View Components
struct CommunityMessageView: View {
    let message: CommunityMessage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !message.isFromCurrentUser {
                Text(message.username)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if message.isFromCurrentUser {
                    Spacer()
                    
                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Spacer()
                }
            }
            
            Text(message.timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: message.isFromCurrentUser ? .trailing : .leading)
        }
    }
}

struct ConversationRowView: View {
    let conversation: Conversation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: conversation.chefAvatar)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(conversation.chefName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(conversation.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(conversation.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if conversation.unreadCount > 0 {
                            Text("\(conversation.unreadCount)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DirectMessageView: View {
    let message: DirectMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(red: 1.0, green: 0.12, blue: 0.0))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Spacer()
            }
        }
    }
}

// MARK: - Sample Data
let sampleCommunityMessages = [
    CommunityMessage(
        text: "Just made some amazing pasta carbonara! Anyone want the recipe? 🍝",
        username: "Maria Garcia",
        timestamp: Date().addingTimeInterval(-3600),
        isFromCurrentUser: false
    ),
    CommunityMessage(
        text: "That looks delicious! I'd love the recipe",
        username: "You",
        timestamp: Date().addingTimeInterval(-1800),
        isFromCurrentUser: true
    ),
    CommunityMessage(
        text: "Anyone know a good place to get fresh herbs in the area?",
        username: "Tony Chen",
        timestamp: Date().addingTimeInterval(-900),
        isFromCurrentUser: false
    ),
    CommunityMessage(
        text: "Try the farmers market on Saturdays! They have amazing fresh herbs",
        username: "Sarah Johnson",
        timestamp: Date().addingTimeInterval(-300),
        isFromCurrentUser: false
    )
]

let sampleConversations = [
    Conversation(
        chefName: "Maria Garcia",
        chefAvatar: "https://picsum.photos/150/150?random=1",
        lastMessage: "Thanks for the recipe! It turned out great!",
        timestamp: Date().addingTimeInterval(-1800),
        unreadCount: 2,
        messages: [
            DirectMessage(text: "Hi! I loved your pasta carbonara post", isFromUser: true, timestamp: Date().addingTimeInterval(-3600)),
            DirectMessage(text: "Thank you! Would you like the recipe?", isFromUser: false, timestamp: Date().addingTimeInterval(-3000)),
            DirectMessage(text: "Yes please! That would be amazing", isFromUser: true, timestamp: Date().addingTimeInterval(-2400)),
            DirectMessage(text: "Here's the recipe: [recipe details]", isFromUser: false, timestamp: Date().addingTimeInterval(-1800)),
            DirectMessage(text: "Thanks for the recipe! It turned out great!", isFromUser: true, timestamp: Date().addingTimeInterval(-1800))
        ]
    ),
    Conversation(
        chefName: "Tony Chen",
        chefAvatar: "https://picsum.photos/150/150?random=3",
        lastMessage: "Looking forward to trying your Thai curry!",
        timestamp: Date().addingTimeInterval(-7200),
        unreadCount: 0,
        messages: [
            DirectMessage(text: "Your Thai curry looks amazing!", isFromUser: true, timestamp: Date().addingTimeInterval(-7200)),
            DirectMessage(text: "Thank you! It's one of my favorites", isFromUser: false, timestamp: Date().addingTimeInterval(-7000)),
            DirectMessage(text: "Looking forward to trying your Thai curry!", isFromUser: true, timestamp: Date().addingTimeInterval(-7200))
        ]
    ),
    Conversation(
        chefName: "Sophie Martin",
        chefAvatar: "https://picsum.photos/150/150?random=5",
        lastMessage: "The Coq au Vin was perfect!",
        timestamp: Date().addingTimeInterval(-14400),
        unreadCount: 1,
        messages: [
            DirectMessage(text: "Your Coq au Vin looks incredible!", isFromUser: true, timestamp: Date().addingTimeInterval(-14400)),
            DirectMessage(text: "Merci! It's a family recipe", isFromUser: false, timestamp: Date().addingTimeInterval(-14000)),
            DirectMessage(text: "The Coq au Vin was perfect!", isFromUser: true, timestamp: Date().addingTimeInterval(-14400))
        ]
    )
] 