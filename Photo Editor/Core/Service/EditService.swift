import Foundation
import CoreImage

class EditService {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func adjustBrightness(image: CIImage, value: CGFloat) -> CIImage {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: kCIInputBrightnessKey)
        return filter.outputImage ?? image
    }
    
    func adjustContrast(image: CIImage, value: CGFloat) -> CIImage {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: kCIInputContrastKey)
        return filter.outputImage ?? image
    }
    
    func adjustSaturation(image: CIImage, value: CGFloat) -> CIImage {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: kCIInputSaturationKey)
        return filter.outputImage ?? image
    }
    
    func adjustSharpness(image: CIImage, value: CGFloat) -> CIImage {
        let filter = CIFilter(name: "CISharpenLuminance")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: "inputSharpness")
        return filter.outputImage ?? image
    }
    
    func adjustClarity(image: CIImage, value: CGFloat) -> CIImage {
        // 清晰度调整使用非锐化蒙版
        let sharpened = adjustSharpness(image: image, value: value * 2.0)
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(image, forKey: kCIInputImageKey)
        blurFilter.setValue(2.0, forKey: "inputRadius")
        let blurred = blurFilter.outputImage ?? image
        let composite = CIFilter(name: "CIDifferenceBlendMode")!
        composite.setValue(sharpened, forKey: kCIInputImageKey)
        composite.setValue(blurred, forKey: kCIInputBackgroundImageKey)
        return composite.outputImage ?? image
    }
    
    func cropImage(image: CIImage, rect: CGRect) -> CIImage {
        return image.cropped(to: rect)
    }
    
    func rotateImage(image: CIImage, angle: CGFloat) -> CIImage {
        let filter = CIFilter(name: "CIStraightenFilter")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(angle, forKey: "inputAngle")
        return filter.outputImage ?? image
    }
    
    func applyFilter(image: CIImage, filterName: String) -> CIImage {
        guard let filter = CIFilter(name: filterName) else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage ?? image
    }
    
    func updatePhoto(_ photo: PhotoModel, with imageData: Data) {
        dataManager.updatePhoto(photo, with: imageData)
    }
}
