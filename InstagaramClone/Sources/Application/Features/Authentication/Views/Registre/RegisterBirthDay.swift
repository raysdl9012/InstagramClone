//
//  RegisterBirthDay.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct RegisterBirthDay: View {
    @Environment(\.dismiss) var dismiss
    @State private var birthDate = Date()
    
    var body: some View {
        SkeletonRegister(title: "What's your birth?",
                         description: "User your own birthday, so we can better understand you. You can change this later. This is unless you're a celebrity or something.") {
            Text("You selected: \(formattedDate(birthDate))")
                .padding(.vertical, 20)
                .font(Font.title2.bold())
            
            NavigationButton(text: "Next",
                             isDisable: ageIsValidated) {
                RegisterConditions()
                    .navigationBarBackButtonHidden(true)
            }
            
            
        } footer: {
            DatePicker(
                "Select your birthday",
                selection: $birthDate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact) // Estilo iOS clásico
            .padding(10)
            .foregroundStyle(.orange)
            .font(Font.body.bold())
            .tint(.orange)
        } onBack: {
            dismiss()
        }
    }
}

extension RegisterBirthDay {
    
    private var ageIsValidated: Bool {
        calculateAge(from: birthDate) <= 18
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func calculateAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        return ageComponents.year ?? 0
    }
}

#Preview {
    NavigationStack {
        RegisterBirthDay()
    }
}
