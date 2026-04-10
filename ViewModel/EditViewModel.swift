import Foundation
import SwiftUI
import CoreImage

class EditViewModel: ObservableObject {
    @Published var brightness: CGFloat = 0.0
    @Published var contrast: CGFloat = 1.0
    @Published var saturation: CGFloat = 1.0
    @Published var isCropping: Bool = false
    @Published var cropRect: CGRect = .zero
    @Published var rotationAngle: CGFloat = 0.0
    
    private let editService: EditService
    private let originalImage: CIImage
    private var editedImage: CIImage
    
    init(dataManager: DataManager, image: CIImage) {
        self.editService = EditService(dataManager: dataManager)
        self.originalImage = image
        self.editedImage = image
    }
    
    func updateBrightness(value: CGFloat) {
        brightness = value
        updateImage()
    }
    
    func updateContrast(value: CGFloat) {
        contrast = value
        updateImage()
    }
    
    func updateSaturation(value: CGFloat) {
        saturation = value
        updateImage()
    }
    
    func updateRotation(angle: CGFloat) {
        rotationAngle = angle
        updateImage()
    }
    
    func cropImage(rect: CGRect) {
        cropRect = rect
        isCropping = true
        updateImage()
    }
    
    func applyFilter(filterName: String) {
        editedImage = editService.applyFilter(image: editedImage, filterName: filterName)
    }
    
    func reset() {
        brightness = 0.0
        contrast = 1.0
        saturation = 1.0
        isCropping = false
        cropRect = .zero
        rotationAngle = 0.0
        editedImage = originalImage
    }
    
    func getEditedImage() -> CIImage {
        return editedImage
    }
    
    private func updateImage() {
        var image = originalImage
        
        if isCropping && !cropRect.isEmpty {
            image = editService.cropImage(image: image, rect: cropRect)
        }
        
        if rotationAngle != 0.0 {
            image = editService.rotateImage(image: image, angle: rotationAngle)
        }
        
        image = editService.adjustBrightness(image: image, value: brightness)
        image = editService.adjustContrast(image: image, value: contrast)
        image = editService.adjustSaturation(image: image, value: saturation)
        
        editedImage = image
    }
}
