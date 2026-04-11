import Foundation
import SwiftUI
import Vision
import Combine

class SmartViewModel: ObservableObject {
    @Published var searchResults: [PhotoModel] = []
    @Published var faceDetectionResults: [CGRect] = []
    @Published var sceneClassificationResults: [String] = []
    @Published var duplicatePhotos: [(PhotoModel, PhotoModel)] = []
    @Published var isLoading: Bool = false
    
    private let smartService: SmartService
    
    init(dataManager: DataManager) {
        self.smartService = SmartService(dataManager: dataManager)
    }
    
    func searchPhotos(keyword: String) {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let results = self.smartService.searchPhotos(keyword: keyword)
            DispatchQueue.main.async {
                self.searchResults = results
                self.isLoading = false
            }
        }
    }
    
    func detectFaces(image: CGImage, completion: @escaping () -> Void) {
        isLoading = true
        smartService.detectFaces(image: image) { faceRects in
            DispatchQueue.main.async {
                self.faceDetectionResults = faceRects
                self.isLoading = false
                completion()
            }
        }
    }
    
    func classifyScene(image: CGImage, completion: @escaping () -> Void) {
        isLoading = true
        smartService.classifyScene(image: image) { classifications in
            DispatchQueue.main.async {
                self.sceneClassificationResults = classifications
                self.isLoading = false
                completion()
            }
        }
    }
    
    func detectDuplicates() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let duplicates = self.smartService.detectDuplicates()
            DispatchQueue.main.async {
                self.duplicatePhotos = duplicates
                self.isLoading = false
            }
        }
    }
    
    func clearResults() {
        searchResults = []
        faceDetectionResults = []
        sceneClassificationResults = []
        duplicatePhotos = []
    }
    
    func getTotalPhotos() -> Int {
        return smartService.getTotalPhotos()
    }
    
    func getTotalAlbums() -> Int {
        return smartService.getTotalAlbums()
    }
    
    func getFavoritesCount() -> Int {
        return smartService.getFavoritesCount()
    }
    
    func toggleFavorite(photo: PhotoModel) {
        let updatedPhoto = smartService.toggleFavorite(photo: photo)
        // 更新搜索结果中的照片状态
        searchResults = searchResults.map { $0.id == photo.id ? updatedPhoto : $0 }
    }
}
