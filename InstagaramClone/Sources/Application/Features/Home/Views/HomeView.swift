//
//  HomeView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
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
                
                if viewModel.posts.isEmpty {
                    EmptyView()
                }else {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.posts) { post in
                            PostCardView(post: post)
                        }
                    }
                }
            }
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


#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(VideoControlViewModel())
    }
}
