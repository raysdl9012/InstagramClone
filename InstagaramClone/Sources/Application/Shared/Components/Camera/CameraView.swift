//
//  CameraView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraManager = CameraManager()
    
    let onCapture: (MediaItem) -> Void
    
    private func actionTakePhotoVideo() {
        if cameraManager.mode == .photo {
            // Capturar foto
            cameraManager.capturePhoto { image in
                
                if let image = image {
                    let media = cameraManager.createMediaPhoto(from: image)
                    onCapture(media)
                    dismiss()
                }
            }
        } else {
            // Video: iniciar o detener grabación
            if cameraManager.isRecording {
                cameraManager.stopRecording()
            } else {
                cameraManager.startRecording { videoURL in
                    if let videoURL = videoURL {
                        Task {
                            let media = await cameraManager.createMediaVideo(from: videoURL)
                            await MainActor.run {
                                onCapture(media)
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Vista previa de la cámara
            CameraPreviewView(session: cameraManager.session)
                .ignoresSafeArea()
            
            // Controles de la cámara
            VStack {
                // Top bar
                HStack {
                    Button {
                        if cameraManager.isRecording {
                            cameraManager.stopRecording()
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .disabled(cameraManager.isRecording)
                    
                    Spacer()
                    
                    // Indicador de modo y duración
                    if cameraManager.isRecording {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                                .opacity(cameraManager.isRecording ? 1 : 0)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: cameraManager.isRecording)
                            
                            Text(cameraManager.formatDuration(cameraManager.recordingDuration))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .monospacedDigit()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(20)
                    } else {
                        Text(cameraManager.mode == .photo ? "Foto" : "Video")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    // Botón para cambiar cámara
                    Button {
                        cameraManager.switchCamera()
                    } label: {
                        Image(systemName: "camera.rotate")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .disabled(cameraManager.isRecording)
                }
                .padding()
                
                Spacer()
                
                // Bottom controls
                VStack(spacing: 20) {
                    // Botón de captura
                    Button {
                        actionTakePhotoVideo()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 85, height: 85)
                            
                            if cameraManager.isRecording {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .scaleEffect(cameraManager.isRecording ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: cameraManager.isRecording)
                    }
                    
                    // Selector de modo (Foto/Video)
                    if !cameraManager.isRecording {
                        HStack(spacing: 30) {
                            Button {
                                cameraManager.setMode(.photo)
                            } label: {
                                Text("Foto")
                                    .font(.system(size: 16, weight: cameraManager.mode == .photo ? .bold : .regular))
                                    .foregroundColor(.indigo)
                            }
                            
                            Button {
                                cameraManager.setMode(.video)
                            } label: {
                                Text("Video")
                                    .font(.system(size: 16, weight: cameraManager.mode == .video ? .bold : .regular))
                                    .foregroundColor(.purple)
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 30)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            cameraManager.checkPermissions()
        }
        .onDisappear {
            Logger.log(.camera, message: "Dissmissed")
            cameraManager.stopSession()
        }
    }
}

#Preview {
    CameraView() { image in
        
    }
}
