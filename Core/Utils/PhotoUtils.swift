import Foundation
import UIKit

class PhotoUtils {
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    static func getThumbnail(image: UIImage, size: CGSize) -> UIImage {
        return resizeImage(image: image, targetSize: size)
    }
    
    static func imageToData(image: UIImage, quality: CGFloat = 0.8) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
    
    static func dataToImage(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    static func getImageMetadata(image: UIImage) -> [String: Any] {
        var metadata: [String: Any] = [:]
        
        // 这里可以添加获取图像元数据的逻辑
        metadata["width"] = image.size.width
        metadata["height"] = image.size.height
        metadata["scale"] = image.scale
        
        return metadata
    }
}
