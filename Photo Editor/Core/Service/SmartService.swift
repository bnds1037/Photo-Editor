import Foundation
import Vision

class SmartService {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func searchPhotos(keyword: String) -> [PhotoModel] {
        return dataManager.photos.filter { photo in
            photo.tags.contains { $0.lowercased().contains(keyword.lowercased()) }
                || (photo.location?.lowercased().contains(keyword.lowercased()) ?? false)
        }
    }
    
    func detectFaces(image: CGImage, completion: @escaping ([CGRect]) -> Void) {
        let request = VNDetectFaceRectanglesRequest {(request, error) in
            guard let results = request.results as? [VNFaceObservation] else {
                completion([])
                return
            }
            let faceRects = results.map { $0.boundingBox }
            completion(faceRects)
        }
        
        let handler = VNImageRequestHandler(cgImage: image)
        do {
            try handler.perform([request])
        } catch {
            print("Failed to detect faces: \(error)")
            completion([])
        }
    }
    
    func classifyScene(image: CGImage, completion: @escaping ([String]) -> Void) {
        let request = VNClassifyImageRequest {(request, error) in
            guard let results = request.results as? [VNClassificationObservation], !results.isEmpty else {
                completion([])
                return
            }
            let topClassifications = results.prefix(3).map { $0.identifier }
            completion(topClassifications)
        }
        
        let handler = VNImageRequestHandler(cgImage: image)
        do {
            try handler.perform([request])
        } catch {
            print("Failed to classify scene: \(error)")
            completion([])
        }
    }
    
    // func detectBlur(image: CGImage, completion: @escaping (Bool) -> Void) {
    //     let request = VNDetectBlurRequest {(request, error) in
    //         guard let result = request.results?.first as? VNBlurObservation else {
    //             completion(false)
    //             return
    //         }
    //         completion(result.value > 0.5)
    //     }
    //     
    //     let handler = VNImageRequestHandler(cgImage: image)
    //     do {
    //         try handler.perform([request])
    //     } catch {
    //         print("Failed to detect blur: \(error)")
    //         completion(false)
    //     }
    // }
    
    func detectDuplicates() -> [(PhotoModel, PhotoModel)] {
        var duplicates: [(PhotoModel, PhotoModel)] = []
        let photos = dataManager.photos
        
        for i in 0..<photos.count {
            for j in i+1..<photos.count {
                // 这里简化处理，实际应该比较图像内容
                if photos[i].tags == photos[j].tags && photos[i].location == photos[j].location {
                    duplicates.append((photos[i], photos[j]))
                }
            }
        }
        
        return duplicates
    }
    
    func getTotalPhotos() -> Int {
        return dataManager.photos.count
    }
    
    func getTotalAlbums() -> Int {
        return dataManager.albums.count
    }
    
    func getFavoritesCount() -> Int {
        return dataManager.photos.filter { $0.isFavorite }.count
    }
    
    func toggleFavorite(photo: PhotoModel) -> PhotoModel {
        let updatedPhoto = PhotoModel(
            id: photo.id,
            imageData: photo.imageData,
            createDate: photo.createDate,
            location: photo.location,
            tags: photo.tags,
            albumID: photo.albumID,
            isBlur: photo.isBlur,
            isDuplicate: photo.isDuplicate,
            isFavorite: !photo.isFavorite
        )
        dataManager.photos = dataManager.photos.map { $0.id == photo.id ? updatedPhoto : $0 }
        return updatedPhoto
    }
}
