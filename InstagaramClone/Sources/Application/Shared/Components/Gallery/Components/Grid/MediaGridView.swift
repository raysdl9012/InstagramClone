//
//  MediaGridView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct MediaGridView: View {
    
    @Binding var showCamera: Bool
    
    @EnvironmentObject var photoPickerViewModel: PhotoPickerViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 2),
                GridItem(.flexible(), spacing: 2),
                GridItem(.flexible(), spacing: 2)
            ], spacing: 2) {
                CameraButtonView {
                    showCamera = true
                }
                ForEach(photoPickerViewModel.mediaItems) { item in
                    MediaThumbnailView(
                        item: item,
                        isSelected: photoPickerViewModel.isSelected(item)
                    ) {
                        photoPickerViewModel.selectItem(item)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    MediaGridView(showCamera: .constant(false))
        .environmentObject(PhotoPickerViewModel())
}
