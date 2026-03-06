# Gruby iOS

A food sharing platform connecting home chefs with food lovers. Built with SwiftUI for iOS.

## Features

### For Food Lovers
- Browse homemade meals from local chefs
- Search by cuisine, location, or chef
- Save favorites and track order history
- Direct messaging with chefs
- Location-based food discovery

### For Home Chefs
- Streamlined host verification process
- Dish creation and management
- Order tracking and management
- Professional profile setup

## Tech Stack

| Tool | Purpose |
| --- | --- |
| Swift | Language |
| SwiftUI | UI framework |
| MVVM | Architecture |
| CoreLocation | Location services |
| MapKit | Map integration |

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

```bash
git clone https://github.com/itzkennedydev/gruby-ios.git
cd gruby-ios
open gruby.xcodeproj
```

Build and run on a simulator or device.

## Project Structure

```
gruby/
├── ContentView.swift           # Main tab navigation
├── TabViewComponents.swift     # Tab-specific views
├── BecomeHostView.swift        # Host verification
├── MessageDetailView.swift     # Messaging
├── MessagesView.swift          # Messages list
├── OrdersView.swift            # Order management
├── FavoritesView.swift         # Saved items
├── ProductDetailView.swift     # Dish details
├── SearchComponents.swift      # Search functionality
├── MapComponents.swift         # Location services
├── ListingComponents.swift     # Food listings
├── BottomSheetComponents.swift # Modal presentations
├── LoadingView.swift           # Loading states
└── Assets.xcassets/            # App assets
```

## License

MIT

## Author

**Kennedy Maombi**
- GitHub: [@itzkennedydev](https://github.com/itzkennedydev)
- LinkedIn: [kennedymaombi](https://linkedin.com/in/kennedymaombi)
