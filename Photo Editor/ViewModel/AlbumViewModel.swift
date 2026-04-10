import Foundation
import SwiftUI

class AlbumViewModel: ObservableObject {
    @Published var albums: [AlbumModel] = []
    @Published var selectedAlbum: AlbumModel?
    
    private let albumService: AlbumService
    private let photoService: PhotoService
    
    init(dataManager: DataManager) {
        self.albumService = AlbumService(dataManager: dataManager)
        self.photoService = PhotoService(dataManager: dataManager)
        loadData()
    }
    
    func loadData() {
        albums = albumService.getAlbums()
    }
    
    func createAlbum(name: String, isSmartAlbum: Bool = false) {
        albumService.createAlbum(name: name, isSmartAlbum: isSmartAlbum)
        loadData()
    }
    
    func renameAlbum(album: AlbumModel, newName: String) {
        albumService.renameAlbum(album: album, newName: newName)
        loadData()
    }
    
    func deleteAlbum(album: AlbumModel) {
        albumService.deleteAlbum(album: album)
        loadData()
    }
    
    func selectAlbum(album: AlbumModel) {
        selectedAlbum = album
    }
    
    func getPhotosInAlbum(albumID: UUID) -> [PhotoModel] {
        return photoService.getPhotosByAlbum(albumID: albumID)
    }
    
    func addPhotoToAlbum(photoID: UUID, albumID: UUID) {
        albumService.addPhotoToAlbum(photoID: photoID, albumID: albumID)
        loadData()
    }
    
    func removePhotoFromAlbum(photoID: UUID, albumID: UUID) {
        albumService.removePhotoFromAlbum(photoID: photoID, albumID: albumID)
        loadData()
    }
}
