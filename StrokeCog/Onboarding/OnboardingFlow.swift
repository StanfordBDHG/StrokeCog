//
// This source file is part of the StrokeCog based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziFirebaseAccount
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


/// Displays an multi-step onboarding flow for the StrokeCog.
struct OnboardingFlow: View {
    @Environment(HealthKit.self) private var healthKitDataSource
    @Environment(StrokeCogScheduler.self) private var scheduler

    @AppStorage(StorageKeys.onboardingFlowComplete) private var completedOnboardingFlow = false
    
    @State private var localNotificationAuthorization = false
    
    
    private var healthKitAuthorization: Bool {
        // As HealthKit not available in preview simulator
        if ProcessInfo.processInfo.isPreviewSimulator {
            return false
        }
        
        return healthKitDataSource.authorized
    }
    
    
    var body: some View {
        OnboardingStack(onboardingFlowComplete: $completedOnboardingFlow) {
            Welcome()
            InterestingModules()
            StudyIDView()
            
            if !FeatureFlags.disableFirebase {
                AccountOnboarding()
            }
            
            Consent()
            
            if HKHealthStore.isHealthDataAvailable() && !healthKitAuthorization {
                HealthKitPermissions()
            }
            
            if !localNotificationAuthorization {
                NotificationPermissions()
            }
            
            LocationPermissions()
        }
            .task {
                localNotificationAuthorization = await scheduler.localNotificationAuthorization
            }
            .interactiveDismissDisabled(!completedOnboardingFlow)
    }
}


#if DEBUG
#Preview {
    OnboardingFlow()
        .environment(Account(MockUserIdPasswordAccountService()))
        .previewWith(standard: StrokeCogStandard()) {
            OnboardingDataSource()
            HealthKit()
            AccountConfiguration {
                MockUserIdPasswordAccountService()
            }

            StrokeCogScheduler()
        }
}
#endif
