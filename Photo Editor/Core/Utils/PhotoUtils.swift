import Foundation
import AppKit

class PhotoUtils {
    static func resizeImage(image: NSImage, targetSize: CGSize) -> NSImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        image.draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage.unlockFocus()
        
        return newImage
    }
    
    static func getThumbnail(image: NSImage, size: CGSize) -> NSImage {
        return resizeImage(image: image, targetSize: size)
    }
    
    static func imageToData(image: NSImage, quality: CGFloat = 0.8) -> Data? {
        if let tiffData = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiffData) {
            return bitmap.representation(using: .jpeg, properties: [.compressionFactor: quality])
        }
        return nil
    }
    
    static func dataToImage(data: Data) -> NSImage? {
        return NSImage(data: data)
    }
    
    static func getImageMetadata(image: NSImage) -> [String: Any] {
        var metadata: [String: Any] = [:]
        
        // 这里可以添加获取图像元数据的逻辑
        metadata["width"] = image.size.width
        metadata["height"] = image.size.height
        
        return metadata
    }
}
