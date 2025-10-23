# Gruby iOS 🍴

A food sharing platform connecting home chefs with food lovers. Built with SwiftUI for iOS.

## 🌟 Features

### Core Functionality
- **Food Discovery**: Browse homemade meals from local chefs
- **Search & Filter**: Find specific cuisines, dishes, and chefs
- **Order Management**: Track your food orders and history
- **Messaging**: Direct communication with chefs
- **Favorites**: Save your favorite dishes and chefs

### Host Features
- **Verification System**: Comprehensive host verification process
- **Dish Management**: Easy dish creation and management
- **Order Tracking**: Monitor incoming orders
- **Profile Management**: Professional chef profiles

### Enhanced User Experience
- **Smart Verification Flow**: Separate experiences for verified and unverified users
- **Comprehensive Legal Section**: Complete legal documentation and policies
- **Modern UI**: Clean, intuitive interface with proper icons
- **Location Services**: Find food near you

## 🏗️ Architecture

### Key Components
- **ContentView**: Main tab navigation
- **GrubMainView**: Food discovery and browsing
- **AddDishView**: Dish creation with verification flow
- **ProfileView**: User profiles and settings
- **MessagesView**: Communication system

### Verification System
- **UnverifiedAddDishView**: Onboarding for new hosts
- **VerifiedAddDishView**: Full dish creation for verified hosts
- **BecomeHostView**: Comprehensive host application process

## 🎨 UI/UX Improvements

### Add Dish Screen
- **Separate Views**: Different experiences for verified/unverified users
- **Engaging Onboarding**: Benefits and clear call-to-actions
- **Progress Indicators**: Visual feedback during verification
- **Professional Design**: Clean, modern interface

### Legal Documentation
- **Comprehensive Coverage**: All necessary legal areas
- **Professional Layout**: Clean, organized documentation
- **Easy Navigation**: Clear hierarchy and structure
- **Contact Information**: Multiple ways to reach legal team

## 🛠️ Technical Stack

- **Language**: Swift
- **Framework**: SwiftUI
- **Architecture**: MVVM
- **Navigation**: NavigationView/NavigationStack
- **State Management**: @State, @Binding, @ObservedObject
- **Location Services**: CoreLocation
- **Maps**: MapKit

## 📱 Screenshots

### Main Features
- **Grub Tab**: Food discovery with fork icon
- **Search**: Advanced search functionality
- **Messages**: Communication system
- **Add**: Dish creation with verification
- **Profile**: User management and legal section

### Verification Flow
- **Not Applied**: Encouraging onboarding with benefits
- **Applying**: Progress indicators during submission
- **Pending**: Timeline showing review process
- **Rejected**: Helpful guidance for reapplication

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Clone the repository
```bash
git clone https://github.com/itzkennedydev/gruby-ios.git
```

2. Open in Xcode
```bash
open gruby.xcodeproj
```

3. Build and run on simulator or device

## 📋 Project Structure

```
gruby/
├── ContentView.swift              # Main tab navigation
├── TabViewComponents.swift        # Tab-specific views and components
├── BecomeHostView.swift          # Host verification system
├── MessageDetailView.swift       # Messaging functionality
├── MessagesView.swift            # Messages list
├── OrdersView.swift              # Order management
├── FavoritesView.swift           # Saved items
├── ProductDetailView.swift       # Dish details
├── SearchComponents.swift        # Search functionality
├── MapComponents.swift           # Location services
├── ListingComponents.swift      # Food listings
├── BottomSheetComponents.swift   # Modal presentations
├── LoadingView.swift             # Loading states
└── Assets.xcassets/             # App assets and icons
```

## 🎯 Key Features

### For Food Lovers
- Discover homemade meals from local chefs
- Search by cuisine, location, or chef
- Save favorites and track order history
- Direct messaging with chefs
- Location-based food discovery

### For Home Chefs
- Easy host verification process
- Simple dish creation and management
- Order tracking and management
- Professional profile setup
- Community guidelines and safety standards

## 🔒 Legal & Privacy

### Comprehensive Legal Section
- **Terms of Service**: User agreement and conditions
- **Privacy Policy**: Data collection and protection
- **Cookie Policy**: Cookie usage and tracking
- **Data Protection Rights**: GDPR and CCPA compliance
- **Community Guidelines**: Platform rules and conduct
- **Food Safety Standards**: Health and safety requirements
- **Intellectual Property**: Copyright and trademark policies
- **Dispute Resolution**: Conflict resolution procedures

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Kennedy Maombi**
- GitHub: [@itzkennedydev](https://github.com/itzkennedydev)
- LinkedIn: [kennedy-maombi-947587252](https://linkedin.com/in/kennedy-maombi-947587252)

## 🙏 Acknowledgments

- SwiftUI community for excellent documentation
- iOS developers for best practices
- Food sharing community for inspiration

## 📞 Support

For support, email legal@gruby.com or join our community discussions.

---

**Gruby** - Connecting food lovers with amazing home chefs! 🍽️✨
