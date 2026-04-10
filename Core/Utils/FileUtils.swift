import Foundation

class FileUtils {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func getImagesDirectory() -> URL {
        let documentsDirectory = getDocumentsDirectory()
        let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
        
        do {
            try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create images directory: \(error)")
        }
        
        return imagesDirectory
    }
    
    static func saveImage(data: Data, filename: String) -> URL? {
        let imagesDirectory = getImagesDirectory()
        let fileURL = imagesDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }
    
    static func loadImage(filename: String) -> Data? {
        let imagesDirectory = getImagesDirectory()
        let fileURL = imagesDirectory.appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }
    
    static func deleteImage(filename: String) -> Bool {
        let imagesDirectory = getImagesDirectory()
        let fileURL = imagesDirectory.appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("Failed to delete image: \(error)")
            return false
        }
    }
    
    static func listFiles(in directory: URL) -> [URL] {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            return files
        } catch {
            print("Failed to list files: \(error)")
            return []
        }
    }
}
