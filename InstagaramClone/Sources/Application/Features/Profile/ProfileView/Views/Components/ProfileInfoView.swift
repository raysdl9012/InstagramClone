//
//  ProfileInfoView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ProfileInfoView: View {
    let user: UserEntity
    var body: some View {
        // Biografía
        VStack(alignment: .leading, spacing: 5) {
            Text("\(user.getFullName())")
                .font(.headline)
            if !user.description.isEmpty {
                Text("\(user.description)")
                    .font(.body)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }
}

#Preview {
    ProfileInfoView(user: UserEntity.mock)
}
