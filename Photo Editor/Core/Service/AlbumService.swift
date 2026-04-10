import Foundation

class AlbumService {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func getAlbums() -> [AlbumModel] {
        return dataManager.albums
    }
    
    func createAlbum(name: String, isSmartAlbum: Bool = false) -> AlbumModel {
        let album = AlbumModel(
            id: UUID(),
            name: name,
            createDate: Date(),
            photoIDs: [],
            isSmartAlbum: isSmartAlbum
        )
        dataManager.addAlbum(album)
        return album
    }
    
    func renameAlbum(album: AlbumModel, newName: String) {
        var updatedAlbum = album
        updatedAlbum.name = newName
        dataManager.updateAlbum(updatedAlbum)
    }
    
    func deleteAlbum(album: AlbumModel) {
        dataManager.deleteAlbum(album)
    }
    
    func addPhotoToAlbum(photoID: UUID, albumID: UUID) {
        if let album = dataManager.albums.first(where: { $0.id == albumID }) {
            var updatedAlbum = album
            if !updatedAlbum.photoIDs.contains(photoID) {
                updatedAlbum.photoIDs.append(photoID)
                dataManager.updateAlbum(updatedAlbum)
            }
        }
    }
    
    func removePhotoFromAlbum(photoID: UUID, albumID: UUID) {
        if let album = dataManager.albums.first(where: { $0.id == albumID }) {
            var updatedAlbum = album
            if let index = updatedAlbum.photoIDs.firstIndex(of: photoID) {
                updatedAlbum.photoIDs.remove(at: index)
                dataManager.updateAlbum(updatedAlbum)
            }
        }
    }
}
