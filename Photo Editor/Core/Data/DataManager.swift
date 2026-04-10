import Foundation
import CoreData

class DataManager: ObservableObject {
    @Published var photos: [PhotoModel] = []
    @Published var albums: [AlbumModel] = []
    
    private let coreDataStack = CoreDataStack.shared
    
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        // 加载示例数据
        let samplePhotos = [
            PhotoModel(
                id: UUID(),
                imageData: Data(),
                createDate: Date(),
                location: "New York",
                tags: ["Travel", "City"],
                albumID: nil,
                isBlur: false,
                isDuplicate: false
            ),
            PhotoModel(
                id: UUID(),
                imageData: Data(),
                createDate: Date().addingTimeInterval(-86400),
                location: "Paris",
                tags: ["Travel", "Landmark"],
                albumID: nil,
                isBlur: false,
                isDuplicate: false
            ),
            PhotoModel(
                id: UUID(),
                imageData: Data(),
                createDate: Date().addingTimeInterval(-172800),
                location: "Tokyo",
                tags: ["Travel", "City"],
                albumID: nil,
                isBlur: false,
                isDuplicate: false
            )
        ]
        
        let sampleAlbums = [
            AlbumModel(
                id: UUID(),
                name: "My Photos",
                createDate: Date(),
                photoIDs: samplePhotos.map { $0.id },
                isSmartAlbum: false
            ),
            AlbumModel(
                id: UUID(),
                name: "Travel",
                createDate: Date().addingTimeInterval(-86400),
                photoIDs: samplePhotos.map { $0.id },
                isSmartAlbum: false
            )
        ]
        
        photos = samplePhotos
        albums = sampleAlbums
    }
    
    func addPhoto(_ photo: PhotoModel) {
        photos.append(photo)
    }
    
    func deletePhoto(_ photo: PhotoModel) {
        photos.removeAll { $0.id == photo.id }
        albums.forEach { album in
            if let index = album.photoIDs.firstIndex(of: photo.id) {
                var updatedAlbum = album
                updatedAlbum.photoIDs.remove(at: index)
                if let albumIndex = albums.firstIndex(where: { $0.id == album.id }) {
                    albums[albumIndex] = updatedAlbum
                }
            }
        }
    }
    
    func addAlbum(_ album: AlbumModel) {
        albums.append(album)
    }
    
    func updateAlbum(_ album: AlbumModel) {
        if let index = albums.firstIndex(where: { $0.id == album.id }) {
            albums[index] = album
        }
    }
    
    func deleteAlbum(_ album: AlbumModel) {
        albums.removeAll { $0.id == album.id }
        photos = photos.map { photo in
            if photo.albumID == album.id {
                return PhotoModel(
                    id: photo.id,
                    imageData: photo.imageData,
                    createDate: photo.createDate,
                    location: photo.location,
                    tags: photo.tags,
                    albumID: nil,
                    isBlur: photo.isBlur,
                    isDuplicate: photo.isDuplicate
                )
            }
            return photo
        }
    }
}
