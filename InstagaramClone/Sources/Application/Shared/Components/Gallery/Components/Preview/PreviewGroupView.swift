//
//  GalleryPreviewVew.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PreviewGroupView: View {
    
    @EnvironmentObject var photoPickerViewModel: PhotoPickerViewModel
    
    var body: some View {
        Group {
            if let mediaItem = photoPickerViewModel.selectedItem {
                PreviewPhotoGalleryView(mediaItem: mediaItem)
                    .frame(height: 350)
            } else {
                // Estado vacío
                EmptyStateView()
                    .frame(height: 350)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8),
                   value: photoPickerViewModel.selectedItem?.id)
         
    }
}

#Preview {
    PreviewGroupView()
        .environmentObject(PhotoPickerViewModel())
}
