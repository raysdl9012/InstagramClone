//
//  SelectionMultimediaView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct SelectionMultimediaView: View {
    @Binding var showMultimedia: Bool
    @Binding var isPickerPresented: Bool
    @Binding var isShowingImagePicker: Bool
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .font(Font.system(size: 25))
                    .foregroundStyle(Color.white)
                    .background(.black.opacity(0.6))
                    .clipShape(Circle())
                    .padding(30)
                    .onTapGesture{
                        showMultimedia = false
                    }
                Spacer()
                CustomButtonRegister(title: "Camera",
                                     isDisable: false,
                                     secondary: true) {
                    showMultimedia = false
                    isShowingImagePicker = true
                }.padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                CustomButtonRegister(title: "Gallery",
                                     isDisable: false,
                                     secondary: false) {
                    showMultimedia = false
                    isPickerPresented = true
                }.padding(.horizontal, 20)
            }
            .frame(height: 300)
            .cornerRadius(10)
            .shadow(radius: 20)
            .background(.black.opacity(0.9))
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
    }
}

#Preview {
    SelectionMultimediaView(showMultimedia: .constant(true),
                            isPickerPresented: .constant(true),
                            isShowingImagePicker: .constant(true))
}
