//
//  HomeView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    let username = "@rsdl"
    let likes = "10"
    
    @State private var focusedVideoID: UUID?
    
    
    // Función de Ayuda: Lógica para determinar el foco
    func checkVideoFocus(postID: UUID, postFrame: CGRect, containerCenter: CGFloat) {
        let centerDistance = abs(postFrame.midY - containerCenter)
        let focusThreshold: CGFloat = 100
        
        if centerDistance < focusThreshold {
            if focusedVideoID != postID {
                focusedVideoID = postID
            }
        } else if focusedVideoID == postID && centerDistance > 150 {
            // Desenfoque más agresivo si sale del área central
            focusedVideoID = nil
        }
    }
    
    
    @State private var selected = 0
    var body: some View {
        NavigationStack {
         
            ScrollView {
                VStack{
                    HStack {
                        VStack(alignment: .center, spacing: 8) {
                            ZStack{
                                Image("logo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 20)
                                
                                CircleBorderSegment(start: 0.0, end: 0.15)   // primer punto
                                CircleBorderSegment(start: 0.33, end: 0.48) // segundo punto
                                CircleBorderSegment(start: 0.66, end: 0.82) // tercer punto
                            }
                            
                            
                            Text("@STEVEN_DZA")
                                .font(.caption2)
                        }
                        
                        VStack(alignment: .center, spacing: 8) {
                            ZStack{
                                Image("logo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 20)
                                
                                CircleBorderSegment(start: 0.0, end: 0.15)   // primer punto
                                CircleBorderSegment(start: 0.33, end: 0.48) // segundo punto
                                CircleBorderSegment(start: 0.66, end: 0.82) // tercer punto
                            }
                            
                            
                            Text("@STEVEN_DZA")
                                .font(.caption2)
                        }
                        
                        VStack(alignment: .center, spacing: 8) {
                            ZStack{
                                Image("logo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 20)
                                
                                CircleBorderSegment(start: 0.0, end: 0.15)   // primer punto
                                CircleBorderSegment(start: 0.33, end: 0.48) // segundo punto
                                CircleBorderSegment(start: 0.66, end: 0.82) // tercer punto
                            }
                            
                            
                            Text("@STEVEN_DZA")
                                .font(.caption2)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
                
                ForEach(PostEntity.mock) { post in
                    PostCardView(post: post, isFocused: $focusedVideoID)
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            leadingToolbarItem { }
            principalToolbarItem(title: "Instagram")
            trailingToolbarItem { }
        }
    }
}

struct CircleBorderSegment: View {
    var start: CGFloat
    var end: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: start, to: end) // Dibuja solo una porción del círculo
            .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .rotationEffect(.degrees(-90)) // Comienza desde la parte superior
            .frame(width: 58, height: 58)
    }
}

struct ToolbarTabButton: View {
    let title: String
    let index: Int
    @Binding var selected: Int
    let color: Color
    
    var body: some View {
        Button {
            selected = index
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(selected == index ? color : .gray)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(selected == index ? color.opacity(0.15) : .clear)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
