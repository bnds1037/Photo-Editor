import Foundation
import SwiftUI
import CoreImage
import Combine

class EditViewModel: ObservableObject {
    @Published var brightness: CGFloat = 0.0
    @Published var contrast: CGFloat = 1.0
    @Published var saturation: CGFloat = 1.0
    @Published var sharpness: CGFloat = 0.0
    @Published var clarity: CGFloat = 0.0
    @Published var isCropping: Bool = false
    @Published var cropRect: CGRect = .zero
    @Published var rotationAngle: CGFloat = 0.0
    
    // 工具状态
    @Published var activeTool: ToolType = .adjust
    
    enum ToolType: String, CaseIterable {
        case crop = "Crop"
        case adjust = "Adjust"
        case filters = "Filters"
    }
    
    func setActiveTool(_ tool: ToolType) {
        activeTool = tool
        if tool == .crop {
            isCropping = true
        } else {
            isCropping = false
        }
    }
    
    private let editService: EditService
    private let originalImage: CIImage
    private var editedImage: CIImage
    private let photoModel: PhotoModel?
    
    // 历史记录管理
    private var history: [CIImage] = []
    private var historyIndex: Int = -1
    
    init(dataManager: DataManager, image: CIImage, photoModel: PhotoModel? = nil) {
        self.editService = EditService(dataManager: dataManager)
        self.originalImage = image
        self.editedImage = image
        self.photoModel = photoModel
        // 初始化历史记录
        addToHistory()
    }
    
    func save() {
        guard let photoModel = photoModel else { return }
        
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(editedImage, from: editedImage.extent) {
            let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
            if let data = bitmapRep.representation(using: .png, properties: [:]) {
                // 调用 DataManager 的方法来更新图片
                editService.updatePhoto(photoModel, with: data)
            }
        }
    }
    
    func export() {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(editedImage, from: editedImage.extent) {
            let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
            if let data = bitmapRep.representation(using: .png, properties: [:]) {
                // 打开文件保存面板
                let panel = NSSavePanel()
                panel.allowedFileTypes = ["png"]
                panel.nameFieldStringValue = "edited_image.png"
                
                panel.begin { result in
                    if result == .OK, let url = panel.url {
                        do {
                            try data.write(to: url)
                            print("Image exported to: \(url.path)")
                        } catch {
                            print("Error exporting image: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func undo() {
        if historyIndex > 0 {
            historyIndex -= 1
            editedImage = history[historyIndex]
            // 恢复参数
            updateParametersFromImage()
        }
    }
    
    func redo() {
        if historyIndex < history.count - 1 {
            historyIndex += 1
            editedImage = history[historyIndex]
            // 恢复参数
            updateParametersFromImage()
        }
    }
    
    private func addToHistory() {
        // 移除当前索引之后的历史记录
        if historyIndex < history.count - 1 {
            history = Array(history.prefix(historyIndex + 1))
        }
        // 添加当前状态到历史记录
        history.append(editedImage)
        historyIndex += 1
        // 限制历史记录长度
        if history.count > 50 {
            history.removeFirst()
            historyIndex -= 1
        }
    }
    
    private func updateParametersFromImage() {
        // 这里简化处理，实际应用中可能需要更复杂的参数恢复逻辑
        // 暂时保持当前参数不变
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
    
    func updateSharpness(value: CGFloat) {
        sharpness = value
        updateImage()
    }
    
    func updateClarity(value: CGFloat) {
        clarity = value
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
        addToHistory()
    }
    
    func reset() {
        brightness = 0.0
        contrast = 1.0
        saturation = 1.0
        sharpness = 0.0
        clarity = 0.0
        isCropping = false
        cropRect = .zero
        rotationAngle = 0.0
        editedImage = originalImage
    }
    
    func getEditedImage() -> CIImage {
        return editedImage
    }
    
    func getEditedNSImage() -> NSImage {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(editedImage, from: editedImage.extent) {
            return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        }
        return NSImage()
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
        image = editService.adjustSharpness(image: image, value: sharpness)
        image = editService.adjustClarity(image: image, value: clarity)
        
        editedImage = image
        addToHistory()
    }
}
