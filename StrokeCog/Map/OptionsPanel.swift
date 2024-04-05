//
//  OptionsPanel.swift
//  StrokeCog
//
//  Created by Vishnu Ravi on 4/4/24.
//

import Spezi
import SwiftUI

struct OptionsPanel: View {
    @AppStorage(StorageKeys.trackingPreference) private var trackingOn = true
    @Environment(LocationModule.self) private var locationModule
    
    @State private var showingSurveyAlert = false
    @State private var alertMessage = ""
    @State private var showingSurvey = false
    
    var body: some View {
        GroupBox {
            Button {
                self.showingSurvey.toggle()
            } label: {
                Text("OPTIONS_PANEL_SURVEY_BUTTON")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            .alert(isPresented: $showingSurveyAlert) {
                Alert(
                    title: Text("OPTIONS_ALERT_SURVEY_NOT_AVAILABLE"),
                    message: Text(self.alertMessage),
                    dismissButton: .default(Text("OPTIONS_ALERT_OK"))
                )
            }
            .sheet(isPresented: $showingSurvey) {
                // TODO: Launch Survey
            }
        }
        
        GroupBox {
            Toggle("TRACK_LOCATION_BUTTON", isOn: $trackingOn)
                .onChange(of: trackingOn) { _ in
                    if trackingOn {
                        locationModule.startTracking()
                    } else {
                        locationModule.stopTracking()
                    }
                }
        }
    }
}

#Preview {
    OptionsPanel()
}