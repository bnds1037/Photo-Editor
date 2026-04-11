import Foundation

class PhotoService {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func getPhotos() -> [PhotoModel] {
        return dataManager.photos
    }
    
    func getPhotosByAlbum(albumID: UUID) -> [PhotoModel] {
        return dataManager.photos.filter { $0.albumID == albumID }
    }
    
    func importPhoto(imageData: Data, location: String?, tags: [String]) -> PhotoModel {
        return importPhoto(imageData: imageData, createDate: Date(), location: location, tags: tags, isFavorite: false)
    }
    
    func importPhoto(imageData: Data, createDate: Date, location: String?, tags: [String]) -> PhotoModel {
        return importPhoto(imageData: imageData, createDate: createDate, location: location, tags: tags, isFavorite: false)
    }
    
    func importPhoto(imageData: Data, createDate: Date, location: String?, tags: [String], isFavorite: Bool) -> PhotoModel {
        let photo = PhotoModel(
            id: UUID(),
            imageData: imageData,
            createDate: createDate,
            location: location,
            tags: tags,
            albumID: nil,
            isBlur: false,
            isDuplicate: false,
            isFavorite: isFavorite
        )
        dataManager.addPhoto(photo)
        return photo
    }
    
    func deletePhoto(photo: PhotoModel) {
        dataManager.deletePhoto(photo)
    }
    
    func movePhoto(photo: PhotoModel, toAlbum albumID: UUID?) {
        let updatedPhoto = PhotoModel(
            id: photo.id,
            imageData: photo.imageData,
            createDate: photo.createDate,
            location: photo.location,
            tags: photo.tags,
            albumID: albumID,
            isBlur: photo.isBlur,
            isDuplicate: photo.isDuplicate,
            isFavorite: photo.isFavorite
        )
        dataManager.photos = dataManager.photos.map { $0.id == photo.id ? updatedPhoto : $0 }
        if let albumID = albumID {
            if let album = dataManager.albums.first(where: { $0.id == albumID }) {
                var updatedAlbum = album
                if !updatedAlbum.photoIDs.contains(photo.id) {
                    updatedAlbum.photoIDs.append(photo.id)
                    dataManager.updateAlbum(updatedAlbum)
                }
            }
        }
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
    
    func uploadPhotos(from fileURLs: [URL]) -> [PhotoModel] {
        var uploadedPhotos: [PhotoModel] = []
        
        for fileURL in fileURLs {
            do {
                let imageData = try Data(contentsOf: fileURL)
                // 从文件属性中获取创建日期
                let createDate = getFileCreationDate(from: fileURL)
                // 尝试从文件元数据中获取位置信息（这里简化处理）
                let location: String? = nil
                // 尝试从文件名或内容中提取标签（这里简化处理）
                let tags: [String] = []
                
                let photo = importPhoto(imageData: imageData, createDate: createDate, location: location, tags: tags)
                uploadedPhotos.append(photo)
            } catch {
                print("Failed to upload photo from \(fileURL): \(error)")
            }
        }
        
        return uploadedPhotos
    }
    
    private func getFileCreationDate(from fileURL: URL) -> Date {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            if let creationDate = attributes[.creationDate] as? Date {
                return creationDate
            }
        } catch {
            print("Failed to get file creation date: \(error)")
        }
        // 如果获取失败，返回当前日期
        return Date()
    }
}
