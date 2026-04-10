import Foundation
import Photos
import AVFoundation
import CoreLocation

class PermissionManager {
    static let shared = PermissionManager()
    
    private init() {}
    
    func requestPhotoLibraryPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    func requestCameraPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func requestLocationPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            let locationManager = CLLocationManager()
            // macOS doesn't require explicit authorization request for location
            let status = CLLocationManager.authorizationStatus()
            continuation.resume(returning: status == .authorized)
        }
    }
    
    func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        return status == .authorized
    }
    
    func checkCameraPermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .authorized
    }
    
    func checkLocationPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorized
    }
}
