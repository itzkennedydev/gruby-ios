//
//  BecomeHostView.swift
//  gruby
//
//  Created by Kennedy Maombi on 7/31/25.
//

import SwiftUI
import UIKit

// MARK: - Host Verification Status
enum HostVerificationStatus {
    case notApplied
    case applying
    case pending
    case approved
    case rejected
}

// MARK: - Supporting Views
struct StatusRow: View {
    let icon: String
    let text: String
    let isComplete: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(isComplete ? .black : .secondary)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isComplete ? .black : .secondary)
            
            Spacer()
        }
    }
}

struct TimelineItem: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 28, height: 28)
                
                Text(number)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct NextStepRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.black)
        }
    }
}

struct ReasonRow: View {
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

// MARK: - VerificationPendingView
struct VerificationPendingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer()
                    .frame(height: 60)
                
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "hourglass")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundColor(.black)
                }
                
                // Status Info
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Application Under Review")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Your application is being reviewed")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    
                    // Status Card
                    VStack(alignment: .leading, spacing: 16) {
                        StatusRow(
                            icon: "checkmark.circle.fill",
                            text: "Application Submitted",
                            isComplete: true
                        )
                        
                        StatusRow(
                            icon: "hourglass",
                            text: "Background Check in Progress",
                            isComplete: false
                        )
                        
                        StatusRow(
                            icon: "checkmark.shield",
                            text: "Verification Pending",
                            isComplete: false
                        )
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Timeline Info
                    VStack(spacing: 12) {
                        Text("What happens next?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            TimelineItem(number: "1", text: "We review your application and kitchen photos")
                            TimelineItem(number: "2", text: "Background check is conducted for safety")
                            TimelineItem(number: "3", text: "You'll receive an email with the decision")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Typical review time: 2-3 business days")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
    }
}

// MARK: - VerificationApprovedView
struct VerificationApprovedView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer()
                    .frame(height: 60)
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 56, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Congratulations
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Congratulations!")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("You're now a verified host")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    
                    // Next Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        NextStepRow(icon: "plus.circle", text: "Create your first dish listing")
                        NextStepRow(icon: "photo", text: "Upload appetizing photos")
                        NextStepRow(icon: "dollarsign", text: "Set your prices")
                        NextStepRow(icon: "bell", text: "Start receiving orders")
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // CTA Button
                    Button(action: {
                        // Navigate to add dish
                    }) {
                        Text("Create First Dish")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
    }
}

// MARK: - VerificationRejectedView
struct VerificationRejectedView: View {
    @Binding var verificationStatus: HostVerificationStatus
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer()
                    .frame(height: 60)
                
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundColor(.black)
                }
                
                // Rejection Info
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Application Not Approved")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("We couldn't approve your application at this time")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Reasons
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Common reasons")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ReasonRow(text: "Incomplete application information")
                            ReasonRow(text: "Kitchen photos don't meet requirements")
                            ReasonRow(text: "Missing required certifications")
                            ReasonRow(text: "Background check issues")
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            verificationStatus = .notApplied
                        }) {
                            Text("Reapply")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button(action: {
                            // Contact support
                        }) {
                            Text("Contact Support")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.systemGray5), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
    }
}

// MARK: - BecomeHostView
struct BecomeHostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var verificationStatus: HostVerificationStatus = .notApplied
    
    var body: some View {
        NavigationView {
            Group {
                switch verificationStatus {
                case .notApplied:
                    HostApplicationView(verificationStatus: $verificationStatus)
                case .applying:
                    VerificationPendingView()
                case .pending:
                    VerificationPendingView()
                case .approved:
                    VerificationApprovedView()
                case .rejected:
                    VerificationRejectedView(verificationStatus: $verificationStatus)
                }
            }
            .navigationTitle("Become a Host")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - HostApplicationView
struct HostApplicationView: View {
    @Binding var verificationStatus: HostVerificationStatus
    
    // Personal Information
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var dateOfBirth = Date()
    
    // Address Information
    @State private var address = ""
    @State private var apartmentUnit = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    
    // Culinary Background
    @State private var bio = ""
    @State private var cuisineSpecialties = ""
    @State private var yearsOfExperience = ""
    @State private var professionalExperience = false
    @State private var professionalDetails = ""
    
    // Kitchen Information
    @State private var selectedImages: [UIImage] = []
    @State private var kitchenSize = ""
    @State private var hasCommercialKitchen = false
    @State private var kitchenEquipment: Set<String> = []
    
    // Certifications & Safety
    @State private var hasFoodHandlersCert = false
    @State private var certificationNumber = ""
    @State private var hasBusinessLicense = false
    @State private var businessLicenseNumber = ""
    
    // Availability
    @State private var availableDays: Set<String> = []
    @State private var maxOrdersPerWeek = ""
    
    // References & Social
    @State private var instagramHandle = ""
    @State private var referenceEmail = ""
    
    // Legal
    @State private var agreeToTerms = false
    @State private var agreeToBackgroundCheck = false
    @State private var confirmOver18 = false
    
    // UI State
    @State private var showingImagePicker = false
    @State private var currentSection = 0
    
    let equipmentOptions = ["Oven", "Stove", "Microwave", "Refrigerator", "Freezer", "Food Processor", "Mixer", "Grill"]
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Info
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Start Sharing Your Culinary Passion")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Join our community of home chefs and share your delicious homemade meals with food lovers in your area.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                
                // Benefits Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Why become a host?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 12) {
                        BenefitRow(icon: "dollarsign.circle", text: "Earn money doing what you love")
                        BenefitRow(icon: "calendar", text: "Set your own schedule and prices")
                        BenefitRow(icon: "person.3", text: "Build a community of food lovers")
                        BenefitRow(icon: "shield.checkmark", text: "Safe and secure platform")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                Divider()
                    .padding(.bottom, 24)
                
                // Progress Indicator
                ProgressBarView(currentStep: currentSection, totalSteps: 7)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                
                // Application Form Sections
                VStack(alignment: .leading, spacing: 40) {
                    // Section 1: Personal Information
                    FormSection(
                        icon: "person.circle",
                        title: "Personal Information",
                        subtitle: "Tell us about yourself"
                    ) {
                        VStack(spacing: 16) {
                            FormField(label: "Full Legal Name", text: $fullName, placeholder: "John Doe", required: true)
                            FormField(label: "Email Address", text: $email, placeholder: "john@example.com", required: true)
                            FormField(label: "Phone Number", text: $phoneNumber, placeholder: "(555) 123-4567", required: true)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 4) {
                                    Text("Date of Birth")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("*")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                Text("Must be 18 years or older")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Section 2: Address
                    FormSection(
                        icon: "mappin.circle",
                        title: "Kitchen Address",
                        subtitle: "Where will you prepare the food?"
                    ) {
                        VStack(spacing: 16) {
                            FormField(label: "Street Address", text: $address, placeholder: "123 Main Street", required: true)
                            FormField(label: "Apartment/Unit #", text: $apartmentUnit, placeholder: "Apt 4B (optional)", required: false)
                            
                            HStack(spacing: 12) {
                                FormField(label: "City", text: $city, placeholder: "San Francisco", required: true)
                                FormField(label: "State", text: $state, placeholder: "CA", required: true)
                            }
                            
                            FormField(label: "ZIP Code", text: $zipCode, placeholder: "94102", required: true)
                        }
                    }
                    
                    // Section 3: Culinary Background
                    FormSection(
                        icon: "fork.knife",
                        title: "Culinary Background",
                        subtitle: "Share your cooking experience"
                    ) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 4) {
                                    Text("About You")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("*")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                
                                TextEditor(text: $bio)
                                    .frame(height: 120)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(.systemGray5), lineWidth: 1)
                                    )
                                
                                Text("Tell us about your cooking journey, what inspires you, and what makes your food special (min. 100 characters)")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            
                            FormField(label: "Cuisine Specialties", text: $cuisineSpecialties, placeholder: "Italian, Thai, Mexican, etc.", required: true)
                            FormField(label: "Years of Cooking Experience", text: $yearsOfExperience, placeholder: "e.g., 5", required: true)
                            
                            Toggle(isOn: $professionalExperience) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Professional Culinary Experience")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("Have you worked in restaurants, catering, or food service?")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            
                            if professionalExperience {
                                FormField(label: "Professional Details", text: $professionalDetails, placeholder: "Restaurant names, positions held, etc.", required: false)
                            }
                        }
                    }
                    
                    // Section 4: Kitchen Information & Photos
                    FormSection(
                        icon: "photo.on.rectangle",
                        title: "Kitchen Information",
                        subtitle: "Help us understand your kitchen setup"
                    ) {
                        VStack(spacing: 16) {
                            // Kitchen Size
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 4) {
                                    Text("Kitchen Size")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("*")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                
                                HStack(spacing: 12) {
                                    ForEach(["Small", "Medium", "Large"], id: \.self) { size in
                                        Button(action: {
                                            kitchenSize = size
                                        }) {
                                            Text(size)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(kitchenSize == size ? .white : .black)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 10)
                                                .background(kitchenSize == size ? Color.black : Color(.systemGray6))
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                }
                            }
                            
                            // Kitchen Equipment
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 4) {
                                    Text("Available Equipment")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("*")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                
                                Text("Select all that apply")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(equipmentOptions, id: \.self) { equipment in
                                        Button(action: {
                                            if kitchenEquipment.contains(equipment) {
                                                kitchenEquipment.remove(equipment)
                                            } else {
                                                kitchenEquipment.insert(equipment)
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: kitchenEquipment.contains(equipment) ? "checkmark.square.fill" : "square")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(kitchenEquipment.contains(equipment) ? .black : .secondary)
                                                Text(equipment)
                                                    .font(.system(size: 14, weight: .regular))
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                }
                            }
                            
                            // Kitchen Photos
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 4) {
                                    Text("Kitchen Photos")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("*")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                
                                Text("Upload 3-5 clear photos of your kitchen workspace, cooking area, and food preparation surfaces")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                if selectedImages.isEmpty {
                                    Button(action: {
                                        showingImagePicker = true
                                    }) {
                                        VStack(spacing: 12) {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .font(.system(size: 32, weight: .ultraLight))
                                                .foregroundColor(Color(.systemGray3))
                                            
                                            Text("Add Photos")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 140)
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
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
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    
                                                    Button(action: {
                                                        selectedImages.remove(at: index)
                                                    }) {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .font(.system(size: 20))
                                                            .foregroundColor(.white)
                                                            .background(Color.black.opacity(0.6))
                                                            .clipShape(Circle())
                                                    }
                                                    .padding(6)
                                                }
                                            }
                                            
                                            if selectedImages.count < 5 {
                                                Button(action: {
                                                    showingImagePicker = true
                                                }) {
                                                    VStack(spacing: 8) {
                                                        Image(systemName: "plus")
                                                            .font(.system(size: 20, weight: .regular))
                                                        Text("Add")
                                                            .font(.system(size: 12, weight: .regular))
                                                    }
                                                    .foregroundColor(.secondary)
                                                    .frame(width: 100, height: 100)
                                                    .background(Color(.systemGray6))
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Section 5: Certifications & Safety
                    FormSection(
                        icon: "checkmark.shield",
                        title: "Certifications & Safety",
                        subtitle: "Food safety is our priority"
                    ) {
                        VStack(spacing: 20) {
                            Toggle(isOn: $hasCommercialKitchen) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Commercial Kitchen Access")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("I have access to a licensed commercial kitchen")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            
                            Divider()
                            
                            Toggle(isOn: $hasFoodHandlersCert) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Food Handler's Certificate")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("I have a valid food handler's or food safety certificate")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            
                            if hasFoodHandlersCert {
                                FormField(label: "Certificate Number (if applicable)", text: $certificationNumber, placeholder: "e.g., FH-12345", required: false)
                            }
                            
                            Divider()
                            
                            Toggle(isOn: $hasBusinessLicense) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Business License")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("I have a business license for food preparation")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            
                            if hasBusinessLicense {
                                FormField(label: "License Number", text: $businessLicenseNumber, placeholder: "Business license number", required: false)
                            }
                        }
                    }
                    
                    // Section 6: Availability & Capacity
                    FormSection(
                        icon: "calendar",
                        title: "Availability & Capacity",
                        subtitle: "When can you prepare meals?"
                    ) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 4) {
                                    Text("Available Days")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("*")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                
                                Text("Select the days you're typically available to cook")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                VStack(spacing: 10) {
                                    ForEach(daysOfWeek, id: \.self) { day in
                                        Button(action: {
                                            if availableDays.contains(day) {
                                                availableDays.remove(day)
                                            } else {
                                                availableDays.insert(day)
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: availableDays.contains(day) ? "checkmark.square.fill" : "square")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(availableDays.contains(day) ? .black : .secondary)
                                                Text(day)
                                                    .font(.system(size: 15, weight: .regular))
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                            .padding(14)
                                            .background(Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }
                            
                            FormField(label: "Max Orders Per Week", text: $maxOrdersPerWeek, placeholder: "e.g., 10", required: true)
                        }
                    }
                    
                    // Section 7: References & Social (Optional)
                    FormSection(
                        icon: "link",
                        title: "Connect & References",
                        subtitle: "Help us learn more about you (optional)"
                    ) {
                        VStack(spacing: 16) {
                            FormField(label: "Instagram Handle", text: $instagramHandle, placeholder: "@yourhandle", required: false)
                            FormField(label: "Reference Email", text: $referenceEmail, placeholder: "reference@example.com", required: false)
                            
                            Text("A reference can be a previous employer, culinary instructor, or someone who can vouch for your cooking skills")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Legal Agreement Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Legal Agreement")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Toggle(isOn: $confirmOver18) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 4) {
                                        Text("I confirm I am 18 years or older")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                        Text("*")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            
                            Divider()
                            
                            Toggle(isOn: $agreeToBackgroundCheck) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 4) {
                                        Text("I consent to a background check")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                        Text("*")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.red)
                                    }
                                    Text("For safety and security purposes")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            
                            Divider()
                            
                            Toggle(isOn: $agreeToTerms) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 4) {
                                        Text("I agree to the Terms & Conditions")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                        Text("*")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.red)
                                    }
                                    Text("Including health, safety, and community guidelines")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                        }
                        .padding(20)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                    }
                    
                    // Submit Button
                    VStack(spacing: 16) {
                        Button(action: {
                            // Submit application to backend
                            withAnimation {
                                verificationStatus = .applying
                            }
                            
                            // Simulate backend submission
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    verificationStatus = .pending
                                }
                            }
                        }) {
                            HStack(spacing: 8) {
                                if verificationStatus == .applying {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Submit Application")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(isFormValid ? Color.black : Color(.systemGray3))
                            .cornerRadius(12)
                        }
                        .disabled(!isFormValid || verificationStatus == .applying)
                        
                        Text("Your application will be reviewed within 24-48 hours. We'll notify you via email and SMS.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.horizontal, 12)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
        .background(Color.white)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImages: $selectedImages, sourceType: .photoLibrary)
        }
    }
    
    var isFormValid: Bool {
        // Personal Information (all required)
        !fullName.isEmpty &&
        !email.isEmpty &&
        !phoneNumber.isEmpty &&
        
        // Address (all required)
        !address.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !zipCode.isEmpty &&
        
        // Culinary Background
        !bio.isEmpty &&
        bio.count >= 100 &&
        !cuisineSpecialties.isEmpty &&
        !yearsOfExperience.isEmpty &&
        
        // Kitchen Info
        !selectedImages.isEmpty &&
        selectedImages.count >= 3 &&
        !kitchenSize.isEmpty &&
        !kitchenEquipment.isEmpty &&
        
        // Availability
        !availableDays.isEmpty &&
        !maxOrdersPerWeek.isEmpty &&
        
        // Legal Requirements
        confirmOver18 &&
        agreeToBackgroundCheck &&
        agreeToTerms
    }
    
}

// MARK: - Supporting Views

struct FormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var required: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                if required {
                    Text("*")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                }
            }
            
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

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.black)
        }
    }
}

struct FormSection<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content
    
    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Header
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }
            
            // Section Content
            content
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

struct ProgressBarView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(min(currentStep + 1, totalSteps))/\(totalSteps) sections")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black)
                        .frame(width: geometry.size.width * CGFloat(min(currentStep + 1, totalSteps)) / CGFloat(totalSteps), height: 6)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .frame(height: 6)
        }
    }
}


// MARK: - Preview
#Preview {
    BecomeHostView()
}
