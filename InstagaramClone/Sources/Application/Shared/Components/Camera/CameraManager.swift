//
//  CameraManager.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import AVFoundation
internal import Combine
import CoreMotion
import Photos

enum CameraMode {
    case photo, video
}

final class CameraManager: NSObject, ObservableObject {
    
    // MARK: - Public Properties
    @Published var isRecording = false
    @Published var mode: CameraMode = .photo
    @Published var recordingDuration: TimeInterval = 0
    @Published var videoOrientation: AVCaptureVideoOrientation = .portrait
    
    // MARK: - Private Properties
    let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var videoOutput = AVCaptureMovieFileOutput()
    private var currentCamera: AVCaptureDevice.Position = .back
    private var recordingTimer: Timer?
    private var videoCompletionHandler: ((URL?) -> Void)?
    private var photoCompletionHandler: ((UIImage?) -> Void)?
    private let motionManager = CMMotionManager()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    override init() {
        super.init()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        setupOrientationObserver()
        startMotionUpdates()
    }
    
    // MARK: - Orientation Handling
    private func setupOrientationObserver() {
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                self?.updateVideoOrientation()
            }
            .store(in: &cancellables)
    }
    
    private func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.3
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }
            let x = data.acceleration.x
            let y = data.acceleration.y
            var newOrientation: AVCaptureVideoOrientation = .portrait
            if abs(y) >= abs(x) {
                newOrientation = y >= 0 ? .portraitUpsideDown : .portrait
            } else {
                newOrientation = x >= 0 ? .landscapeRight : .landscapeLeft
            }
            if newOrientation != self.videoOrientation {
                self.videoOrientation = newOrientation
                self.applyVideoOrientation(newOrientation)
                Logger.log(.camera, message: "📱 New orientation detected - \(newOrientation):\(newOrientation.rawValue)")
            }
        }
    }
    
    private func applyVideoOrientation(_ orientation: AVCaptureVideoOrientation) {
        DispatchQueue.main.async {
            // Movie output (archivo)
            if let vConn = self.videoOutput.connection(with: .video), vConn.isVideoOrientationSupported {
                vConn.videoOrientation = orientation
                vConn.isVideoMirrored = (self.currentCamera == .front)
            }
            
            // Photo output (captura)
            if let phConn = self.photoOutput.connection(with: .video), phConn.isVideoOrientationSupported {
                phConn.videoOrientation = orientation
                phConn.isVideoMirrored = orientation == .portraitUpsideDown
            }
        }
    }
    
    private func updateVideoOrientation() {
        guard let interfaceOrientation = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.interfaceOrientation })
            .first else { return }
        
        let newVideoOrientation: AVCaptureVideoOrientation
        switch interfaceOrientation {
        case .portrait: newVideoOrientation = .portrait
        case .portraitUpsideDown: newVideoOrientation = .portraitUpsideDown
        case .landscapeLeft: newVideoOrientation = .landscapeLeft
        case .landscapeRight: newVideoOrientation = .landscapeRight
        default: newVideoOrientation = .portrait
        }
        
        applyVideoOrientation(newVideoOrientation)
        videoOrientation = newVideoOrientation
    }
    
    // MARK: - Permissions
    public func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            checkAudioPermissions()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted { DispatchQueue.main.async { self?.checkAudioPermissions() } }
            }
        default:
            print("❌ Acceso a la cámara denegado")
        }
    }
    
    private func checkAudioPermissions() {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] _ in
            DispatchQueue.main.async {
                self?.setupCamera()
            }
        }
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }
        
        // Video input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCamera),
              let videoInput = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(videoInput) else {
            session.commitConfiguration()
            return
        }
        session.addInput(videoInput)
        
        // Audio input
        if let audioDevice = AVCaptureDevice.default(for: .audio),
           let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
           session.canAddInput(audioInput) {
            session.addInput(audioInput)
        }
        
        // Outputs
        if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.connection(with: .video)?.preferredVideoStabilizationMode = .auto
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    // MARK: - Photo Capture
    public func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCompletionHandler = completion
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    // MARK: - Camera Switching
    public func switchCamera() {
        currentCamera = currentCamera == .back ? .front : .back
        setupCamera()
    }
    // MARK: - Recording
    public func startRecording(completion: @escaping (URL?) -> Void) {
        guard !isRecording else { return }
        videoCompletionHandler = completion
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")
        try? FileManager.default.removeItem(at: outputURL)
        videoOutput.connection(with: .video)?.videoOrientation = videoOrientation
        videoOutput.startRecording(to: outputURL, recordingDelegate: self)
        isRecording = true
        recordingDuration = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.recordingDuration += 0.1
        }
    }
    // MARK: - Stop Recording
    func stopRecording() {
        guard isRecording else { return }
        videoOutput.stopRecording()
        isRecording = false
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    // MARK: - Set Mode
    func setMode(_ newMode: CameraMode) {
        mode = newMode
    }
    //
    private func deactivateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("⚠️ Error al desactivar audio session: \(error)")
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
        motionManager.stopAccelerometerUpdates()
        recordingTimer?.invalidate()
        recordingTimer = nil
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Cleanup
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        deactivateAudioSession()
        cancellables.forEach { $0.cancel() }
        motionManager.stopAccelerometerUpdates()
        NotificationCenter.default.removeObserver(self)
        Logger.log(.camera, message: "Remove CameraManager 💥")
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        Logger.log(.camera, message: "Start video grabación")
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        Logger.log(.camera, message: "End video grabación")
        if let error = error {
            Logger.log(.camera, message: "Error grabación video: \(error.localizedDescription)", isError: true)
            Task {
                await MainActor.run {
                    self.videoCompletionHandler?(nil)
                }
            }
            return
        }
        Task {
            await MainActor.run {
                self.videoCompletionHandler?(outputFileURL)
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        Logger.log(.camera, message: "Take Photo")
        let orientationNum = photo.metadata[kCGImagePropertyOrientation as String] as? NSNumber ?? -100
        guard let imageData = photo.fileDataRepresentation(), var image = UIImage(data: imageData) else {
            return
        }
        if orientationNum == 1 {
            image = image.rotated(to: .down)
        }
        if orientationNum == 3 {
            image = image.rotated(to: .up)
        }
        let finalImage = image
        Task {
            await MainActor.run {
                self.photoCompletionHandler?(finalImage)
            }
        }
    }
}

// MARK: - Generar thumbnail del video
extension CameraManager {
    public func generateThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
            let finalImage = UIImage(cgImage: cgImage)
            return finalImage
        } catch {
            return nil
        }
    }
    
    public func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func videoAspectRatio(for url: URL) async -> CGFloat {
        let asset = AVAsset(url: url)
        do {
            // Cargar el primer track de video
            let tracks = try await asset.loadTracks(withMediaType: .video)
            guard let track = tracks.first else { return 1.0 }
            // Cargar tamaño y transformación del video
            let size = try await track.load(.naturalSize)
            let transform = try await track.load(.preferredTransform)
            // Aplicar la rotación si es necesario
            let isPortrait = abs(transform.b) == 1.0 && abs(transform.c) == 1.0
            let width = isPortrait ? size.height : size.width
            let height = isPortrait ? size.width : size.height
            let aspectRatio = width / height
            return aspectRatio
        } catch {
            Logger.log(.camera, message: "Error to create aspect ratio", isError: true)
            return 1.0
        }
    }
    
    // Is not necessary to use this function, if you what you can uncomment the call
    private func saveVideoToLibrary(videoURL: URL) async -> PHAsset? {
        var videoAssetPlaceholder: PHObjectPlaceholder?
        do {
            try await PHPhotoLibrary.shared().performChanges {
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                videoAssetPlaceholder = createAssetRequest?.placeholderForCreatedAsset
            }
            if let placeholder = videoAssetPlaceholder {
                let fetchResult = PHAsset.fetchAssets(
                    withLocalIdentifiers: [placeholder.localIdentifier],
                    options: nil
                )
                return fetchResult.firstObject
            }
        } catch {
            Logger.log(.camera, message: "Error \(error.localizedDescription)", isError: true)
        }
        return nil
    }
    
    public func createMediaVideo(from url: URL) async -> MediaItem {
        guard let thumbnail = generateThumbnail(from: url) else {
            Logger.log(.camera, message: "Error generate the thumbnail", isError: true)
            fatalError("Error generate the thumbnail")
        }
        /*
         guard let phAsset = await saveVideoToLibrary(videoURL: url) else {
         Logger.log(.camera, message: "Error generate the phAsset", isError: true)
         fatalError("Error generate the phAsset")
         }*/
        let aspectRatio = await videoAspectRatio(for: url)
        let fixURL = try? await fixOrientation(of: url)
        Logger.log(.camera, message: "Aspect ratio: \(aspectRatio), videoOrientation: \(self.videoOrientation)")
        Logger.log(.camera, message: "New fix url: \(String(describing: fixURL))")
        let newThumbnail = rotateImage(thumbnail, orientation: self.videoOrientation)
        let media = MediaItem(id: UUID().uuidString,
                              thumbnail: newThumbnail,
                              image: newThumbnail,
                              isVideo: true,
                              duration: formatDuration(self.recordingDuration),
                              phAsset: nil, // phAsset
                              videoURL: fixURL,
                              aspectRatio: aspectRatio)
        return media
    }
    
    private func rotateImage(_ image: UIImage, orientation: AVCaptureVideoOrientation) -> UIImage {
        switch orientation {
        case .portrait:
            return image.rotated(to: .up)
        case .landscapeLeft:
            return image.rotated(to: .down)
        case .landscapeRight:
            return image.rotated(to: .down)
        case .portraitUpsideDown:
            return image.rotated(to: .up)
        @unknown default:
            return image
        }
    }
    
    public func createMediaPhoto(from image: UIImage) -> MediaItem {
        MediaItem(id: UUID().uuidString,
                  thumbnail: nil,
                  image: image,
                  isVideo: false,
                  duration: nil,
                  phAsset: nil,
                  videoURL: nil,
                  aspectRatio: image.getAspectRatio())
    }
    
    
    func fixOrientation(of url: URL) async throws -> URL {
        let asset = AVAsset(url: url)
        
        // Cargar datos de video
        let videoTracks = try await asset.loadTracks(withMediaType: .video)
        guard let videoTrack = videoTracks.first else {
            throw NSError(domain: "VideoFix", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se encontró pista de video."])
        }
        
        let naturalSize = try await videoTrack.load(.naturalSize)
        let duration = try await asset.load(.duration)
        
        // Crear composición base
        let composition = AVMutableComposition()
        guard let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video,
                                                                      preferredTrackID: kCMPersistentTrackID_Invalid) else {
            throw NSError(domain: "VideoFix", code: -2, userInfo: [NSLocalizedDescriptionKey: "No se pudo crear track de video mutable."])
        }
        try videoCompositionTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration),
                                                  of: videoTrack,
                                                  at: .zero)
        
        // --- PASO 1: Añadir la pista de audio a la composición (Tu código ya lo hace bien) ---
        var audioCompositionTrack: AVMutableCompositionTrack?
        let audioTracks = try await asset.loadTracks(withMediaType: .audio)
        if let audioTrack = audioTracks.first {
            audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio,
                                                                preferredTrackID: kCMPersistentTrackID_Invalid)
            try audioCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: duration),
                                                       of: audioTrack,
                                                       at: .zero)
        }
        
        // Crear instrucción
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack)
        
        // --- CORRECCIÓN 2: LÓGICA DE ROTACIÓN CORRECTA ---
        var transform = CGAffineTransform.identity
        var renderSize = naturalSize
        
        // Usamos la orientación que capturas de la cámara
        switch self.videoOrientation {
        case .portrait:
            transform = CGAffineTransform(translationX: naturalSize.height,y: 0).rotated(by: .pi / 2)
            renderSize = CGSize(width: naturalSize.height, height: naturalSize.width)
            
        case .landscapeLeft:
            renderSize = naturalSize
            transform = .identity
            
        case .landscapeRight:
            renderSize = naturalSize
            transform = CGAffineTransform(translationX: naturalSize.width,
                                          y: naturalSize.height).rotated(by: .pi)
            
        case .portraitUpsideDown:
            transform = .identity
            renderSize = naturalSize
            
        @unknown default:
            transform = .identity
            renderSize = naturalSize
        }
        
        layerInstruction.setTransform(transform, at: .zero)
        instruction.layerInstructions = [layerInstruction]
        
        // Crear video composition
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = renderSize
        videoComposition.instructions = [instruction]
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        // Configurar exportación
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            throw NSError(domain: "VideoFix", code: -3, userInfo: [NSLocalizedDescriptionKey: "No se pudo crear sesión de exportación"])
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp4")
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        
        // Exportar
        await exportSession.export()
        
        guard exportSession.status == .completed else {
            throw exportSession.error ?? NSError(domain: "VideoFix", code: -4, userInfo: [NSLocalizedDescriptionKey: "Error en exportación"])
        }
        return outputURL
    }
    
}
