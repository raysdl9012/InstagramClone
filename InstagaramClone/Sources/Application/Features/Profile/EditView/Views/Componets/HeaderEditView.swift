//
//  HeaderEditView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import UIKit
import Kingfisher
struct HeaderEditView: View {
    
    var imageUrl: URL?
    @Binding var image: UIImage?
    @Binding var showMultimedia: Bool
    
    var body: some View {
        Section {
            HStack {
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    if let selectedImage = image {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                    } else {
                        KFImage(imageUrl)
                            .placeholder {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.indigo.opacity(0.5))
                                    .frame(width: 100, height: 100)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(Circle())
                            }
                            .resizable()
                            .background(Color.gray.opacity(0.3))
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                    }
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.indigo)
                        .clipShape(Circle())
                        .offset(x: 3, y: 5)
                }
                .onTapGesture {
                    showMultimedia = true
                }
                
                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    HeaderEditView(imageUrl: URL(string: "https://media.gq.com.mx/photos/5eb5954e51cd5e1b340e8b67/4:3/w_1460,h_1095,c_limit/dia-de-goku.png"),
                   //image: .constant(UIImage(named:"logo")),
                   image: .constant(nil),
                   showMultimedia: .constant(false))
}
