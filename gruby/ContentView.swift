//
//  ContentView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI
import BottomSheet
import CoreLocation
import Combine
import MapKit
import _MapKit_SwiftUI



// MARK: - Notification Extensions
extension Notification.Name {
    static let locationPermissionGranted = Notification.Name("locationPermissionGranted")
}


// MARK: - NumberFormatter Extension
extension NumberFormatter {
    static var radiusFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.minimum = 0.1
        formatter.maximum = 5.0
        return formatter
    }
}

// MARK: - ContentView
struct ContentView: View {
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            // Grub Tab
            Tab("Grub", systemImage: "fork.knife") {
                GrubMainView()
                    .searchable(text: $searchText, prompt: "Search for meals, chefs, cuisines...")
            }
            
            // Search Tab - iOS 26+ uses role: .search
            if #available(iOS 18.0, *) {
                Tab(role: .search) {
                    NavigationStack {
                        SearchView(searchText: $searchText)
                            .navigationTitle("Search")
                    }
                }
            } else {
                Tab("Search", systemImage: "magnifyingglass") {
                    NavigationStack {
                        SearchView(searchText: $searchText)
                            .navigationTitle("Search")
                    }
                }
            }
            
            // Messages Tab
            Tab("Messages", systemImage: "message") {
                MessagesView()
            }
            
            // Add Tab
            Tab("Add", systemImage: "plus.circle.fill") {
                AddDishView(userLocation: nil)
            }
            
            // Profile Tab
            Tab("Profile", systemImage: "person.circle") {
                ProfileView()
            }
        }
        .tint(AppColors.primaryColor)
    }
}

// MARK: - GrubMainView
struct GrubMainView: View {
    @State private var selectedCategory: String = "All"
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Background
                AppColors.neutralColor
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header Section
                        HeaderSection()
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 20)
                        
                        // Categories Section
                        CategoriesView()
                            .padding(.bottom, 24)
                        
                        // Listings
                        ListingsView(searchText: "")
                            .padding(.bottom, 20)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(AppColors.primaryColor)
    }
}

// MARK: - AddressLocationManager
final class AddressLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationString: String = "Fetching location..."
    @Published var isLoading = false
    @Published var location: CLLocation?
    
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // Lower accuracy for faster results
        
        // Use a simulated location immediately
        self.simulateLocation()
        
        // Start requesting actual location in the background
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.requestLocationInBackground()
            
            // If already authorized, request location immediately
            if self.locationManager.authorizationStatus == .authorizedWhenInUse || 
               self.locationManager.authorizationStatus == .authorizedAlways {
                self.requestLocation()
                
                // Notify that permission is already granted
                NotificationCenter.default.post(name: .locationPermissionGranted, object: nil)
            } else if self.locationManager.authorizationStatus == .notDetermined {
                // Request permission if not determined yet
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    private func requestLocationInBackground() {
        // Check authorization status first
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func requestLocation() {
        isLoading = true
        
        // Immediately show simulated location
        simulateLocation()
        
        // Then try to get real location with a shorter timeout
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            
            // Add a shorter fallback in case the location request times out
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                if self.isLoading {
                    self.isLoading = false
                }
            }
            
        case .denied, .restricted:
            locationString = "Location access denied"
            isLoading = false
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // Add a shorter fallback in case the user doesn't respond to the permission prompt
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                if self.isLoading {
                    self.isLoading = false
                }
            }
            
        @unknown default:
            locationString = "Using default location"
            isLoading = false
        }
    }
    
    private func simulateLocation() {
        // Simulate a San Francisco location for testing/demo purposes
        let sanFrancisco = CLLocation(latitude: 37.7749, longitude: -122.4194)
        self.location = sanFrancisco
        processLocation(sanFrancisco)
        
        // Provide a default address
        self.locationString = "123 Market Street"
        self.isLoading = false
    }
    
    private func processLocation(_ location: CLLocation) {
        lastLocation = location
        self.location = location
        
        // Set a timeout for geocoding
        var geocodingCompleted = false
        
        // Set a timeout to ensure we don't wait too long for geocoding
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self, !geocodingCompleted else { return }
            
            // If geocoding is taking too long, use coordinates as fallback
            self.locationString = String(format: "%.5f, %.5f", location.coordinate.latitude, location.coordinate.longitude)
            self.isLoading = false
        }
        
        // Try to get the address from the location using modern MapKit
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "address"
        searchRequest.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            
            geocodingCompleted = true
            
            if let mapItem = response?.mapItems.first {
                let placemark = mapItem.placemark
                
                // Try to get a full address with house number
                var addressComponents: [String] = []
                
                // Add house number if available
                if let subThoroughfare = placemark.subThoroughfare {
                    addressComponents.append(subThoroughfare)
                }
                
                // Add street name
                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                }
                
                if !addressComponents.isEmpty {
                    self.locationString = addressComponents.joined(separator: " ")
                } else if let name = placemark.name {
                    // Use POI name if no street address
                    self.locationString = name
                } else {
                    // If we can't get the address, use a default
                    self.locationString = "123 Market Street"
                }
            } else {
                // If we can't get the address, use a default
                self.locationString = "123 Market Street"
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // Process the real location
        processLocation(location)
        
        // End loading state immediately
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
        
        // Keep using the simulated location but end loading state
        isLoading = false
        
        // Only log the error, don't change the location since we already have a simulated one
        if let error = error as? CLError, error.code == .denied {
            locationString = "Location access denied"
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Request location immediately when permission is granted
            locationManager.requestLocation()
            // Set isUsingCurrentLocation to true automatically
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .locationPermissionGranted, object: nil)
            }
        case .denied, .restricted:
            // Keep using simulated location but update the status
            locationString = "Using default location"
            isLoading = false
        case .notDetermined:
            // Wait for user decision
            break
        @unknown default:
            isLoading = false
        }
    }
}

// MARK: - HeaderSection
private struct HeaderSection: View {
    @StateObject private var addressLocationManager = AddressLocationManager()
    @State private var showingAddressPicker = false
    @State private var currentAddress = "Tap to set location"
    @State private var isUsingCurrentLocation = false
    @State private var searchRadius: Double = 0.5
    
    // For notification handling
    @State private var notificationCancellable: AnyCancellable?
    
    var body: some View {
        Button(action: {
            showingAddressPicker = true
        }) {
            HStack(spacing: 10) {
                // Location icon with background
                ZStack {
                    Circle()
                        .fill(Color(red: 255/255, green: 30/255, blue: 0/255, opacity: 0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: isUsingCurrentLocation ? "location.fill" : "mappin")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryColor)
                }
                
                // Address text
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        if isUsingCurrentLocation {
                            if addressLocationManager.isLoading {
                                Text("Finding your location...")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                            } else {
                                Text(addressLocationManager.locationString)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryColor)
                                    .lineLimit(1)
                            }
                            
                            // Current location indicator
                            Circle()
                                .fill(AppColors.primaryColor)
                                .frame(width: 6, height: 6)
                        } else {
                            Text(currentAddress)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.secondaryColor)
                                .lineLimit(1)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "circle.dashed")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                            
                        Text("\(String(format: "%.1f", searchRadius)) mile radius")
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                            
                        Text("•")
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                            
                        Text("\(Int(searchRadius * 10)) listings")
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Edit button
                ZStack {
                    Circle()
                        .fill(AppColors.neutralAccent)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.secondaryColor)
                }
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingAddressPicker) {
            AddressPicker(
                selectedAddress: $currentAddress,
                isUsingCurrentLocation: $isUsingCurrentLocation,
                searchRadius: $searchRadius,
                addressLocationManager: addressLocationManager,
                isPresented: $showingAddressPicker
            )
        }
        .onAppear {
            // Set up notification observer for location permission granted
            notificationCancellable = NotificationCenter.default
                .publisher(for: .locationPermissionGranted)
                .receive(on: RunLoop.main)
                .sink { [self] _ in
                    // Automatically use current location when permission is granted
                    isUsingCurrentLocation = true
                    addressLocationManager.requestLocation()
                }
            
            // Request location if using current location
            if isUsingCurrentLocation {
                addressLocationManager.requestLocation()
            }
        }
        .onChange(of: isUsingCurrentLocation) { oldValue, newValue in
            if newValue {
                addressLocationManager.requestLocation()
            }
        }
    }
}

// MARK: - AddressPicker
private struct AddressPicker: View {
    @Binding var selectedAddress: String
    @Binding var isUsingCurrentLocation: Bool
    @Binding var searchRadius: Double
    @ObservedObject var addressLocationManager: AddressLocationManager
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    // For notification handling
    @State private var notificationCancellable: AnyCancellable?
    
    let savedAddresses = [
        "123 Main St, San Francisco",
        "456 Market St, San Francisco",
        "789 Mission St, San Francisco"
    ]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @State private var mapPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    ))
    @State private var locationTimestamp: TimeInterval = 0
    
    private var userLocation: CLLocationCoordinate2D {
        if let location = addressLocationManager.location?.coordinate {
            // Update the timestamp when location changes
            if locationTimestamp != addressLocationManager.location?.timestamp.timeIntervalSince1970 {
                DispatchQueue.main.async {
                    locationTimestamp = addressLocationManager.location?.timestamp.timeIntervalSince1970 ?? 0
                    updateMapPosition()
                }
            }
            return location
        } else {
            return CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        }
    }
    
    private func updateMapPosition() {
        withAnimation {
            region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
            mapPosition = .region(region)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.neutralColor.ignoresSafeArea()
                    .onAppear {
                        // Initialize map position with current location
                        if let location = addressLocationManager.location {
                            locationTimestamp = location.timestamp.timeIntervalSince1970
                            updateMapPosition()
                        }
                        
                        // Set up notification observer for location permission granted
                        notificationCancellable = NotificationCenter.default
                            .publisher(for: .locationPermissionGranted)
                            .receive(on: RunLoop.main)
                            .sink { [self] _ in
                                // Automatically use current location when permission is granted
                                isUsingCurrentLocation = true
                                selectedAddress = addressLocationManager.locationString
                            }
                    }
                
                VStack(spacing: 0) {
                // Header with search and map
                VStack(spacing: 20) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        TextField("Search for an address", text: $searchText)
                            .font(.system(size: 16))
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(AppColors.neutralColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Real map view
                    ZStack(alignment: .center) {
                        Map(position: $mapPosition) {
                            Marker("Current Location", coordinate: userLocation)
                                .tint(AppColors.primaryColor)
                        }
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onAppear {
                            // Update map position to user location immediately
                            withAnimation {
                                region = MKCoordinateRegion(
                                    center: userLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                                )
                                mapPosition = .region(region)
                            }
                        }
                        // We can't use onChange with CLLocationCoordinate2D directly
                        .id(locationTimestamp)
                    }
                }
                .padding(16)
                
                // Removed search radius section
                
                VStack {
                    // Spacer to maintain layout
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                    
                    // Address options section
                    ScrollView {
                        VStack(spacing: 16) {
                            // Current location button
                            Button(action: {
                                isUsingCurrentLocation = true
                                addressLocationManager.requestLocation()
                                isPresented = false
                            }) {
                                HStack(spacing: 16) {
                                    // Icon with background
                                    ZStack {
                                        Circle()
                                            .fill(AppColors.primaryColor.opacity(0.1))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.black)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Current Location")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.secondaryColor)
                                        
                                        if addressLocationManager.isLoading {
                                            Text("Getting your location...")
                                                .font(.system(size: 14))
                                                .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                                        } else {
                                            Text(addressLocationManager.locationString)
                                                .font(.system(size: 14))
                                                .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if isUsingCurrentLocation {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(16)
                                .background(AppColors.neutralColor)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isUsingCurrentLocation ? AppColors.primaryColor : AppColors.secondaryColor.opacity(0.1), lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Saved addresses section
                            if !savedAddresses.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Saved Addresses")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.secondaryColor)
                                        .padding(.horizontal, 4)
                                    
                                    VStack(spacing: 16) {
                                        ForEach(savedAddresses.filter { searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { address in
                                            Button(action: {
                                                selectedAddress = address
                                                isUsingCurrentLocation = false
                                                isPresented = false
                                            }) {
                                                HStack(spacing: 16) {
                                                    // Icon with background
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(.systemGray5))
                                                            .frame(width: 44, height: 44)
                                                        
                                                        Image(systemName: "house.fill")
                                                            .font(.system(size: 18))
                    .foregroundColor(.secondary)
                                                    }
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(address)
                                                            .font(.system(size: 16, weight: .semibold))
                                                            .foregroundColor(.black)
                                                            .lineLimit(1)
                                                        
                                                        Text("Home")
                                                            .font(.system(size: 14))
                    .foregroundColor(.secondary)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    if !isUsingCurrentLocation && selectedAddress == address {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .font(.system(size: 22))
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                                .padding(16)
                                                .background(AppColors.neutralColor)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(!isUsingCurrentLocation && selectedAddress == address ? AppColors.primaryColor : AppColors.secondaryColor.opacity(0.1), lineWidth: 1)
                                                )
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                            
                            // Add new address button
                            Button(action: {
                                // Action to add new address
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                    
                                    Text("Add New Address")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(AppColors.neutralColor)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.secondaryColor.opacity(0.1), lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Location Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primaryColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryColor)
                }
            })
            .onAppear {
                if isUsingCurrentLocation {
                    addressLocationManager.requestLocation()
                }
            }
        }
    }
}

// MARK: - FeaturedSection
private struct FeaturedSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured Today")
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                
                Spacer()
                
                Button(action: {
                    // View all featured
                }) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(AppColors.primaryColor)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { index in
                        FeaturedCard()
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - FeaturedCard
private struct FeaturedCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Minimal background
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.neutralAccent)
                .frame(width: 280, height: 140)
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text("Top Rated")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppColors.primaryColor)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text("Best Italian Pasta")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.secondaryColor)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Text("450+ orders")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    Text("•")
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                    
                    Text("0.3 mi")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.secondaryColor.opacity(0.6))
                }
            }
            .padding(16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 255/255, green: 30/255, blue: 0/255, opacity: 0.1), lineWidth: 1)
        )
        .shadow(color: Color(white: 0, opacity: 0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
