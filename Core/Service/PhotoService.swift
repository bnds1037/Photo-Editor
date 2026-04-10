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
        let photo = PhotoModel(
            id: UUID(),
            imageData: imageData,
            createDate: Date(),
            location: location,
            tags: tags,
            albumID: nil,
            isBlur: false,
            isDuplicate: false
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
            isDuplicate: photo.isDuplicate
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
}
