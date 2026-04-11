import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import AppKit

struct EditView: View {
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var viewModel: EditViewModel
    
    let image: NSImage
    let photoModel: PhotoModel?
    
    init(image: NSImage, photoModel: PhotoModel? = nil) {
        self.image = image
        self.photoModel = photoModel
        let ciImage = CIImage(data: image.tiffRepresentation ?? Data()) ?? CIImage()
        let dataManager = DataManager()
        self._viewModel = StateObject(wrappedValue: EditViewModel(dataManager: dataManager, image: ciImage, photoModel: photoModel))
    }
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Button(action: { viewModel.undo() }) {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Undo")
                }
                .padding()
                
                Button(action: { viewModel.redo() }) {
                    Image(systemName: "arrow.uturn.forward")
                    Text("Redo")
                }
                .padding()
                
                Button(action: { viewModel.reset() }) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Revert")
                }
                .padding()
                
                Spacer()
                
                Button(action: { viewModel.save() }) {
                    Text("Save")
                }
                .padding()
                
                Button(action: { viewModel.export() }) {
                    Text("Export")
                }
                .padding()
            }
            .padding()
            .background(
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 编辑区域
            HStack {
                // 左侧工具栏
                VStack(spacing: 10) {
                    Button(action: { viewModel.setActiveTool(.crop) }) {
                        VStack(spacing: 5) {
                            Image(systemName: "crop")
                                .font(.system(size: 20))
                            Text("Crop")
                                .font(.system(size: 12))
                        }
                        .frame(width: 80, height: 60)
                        .padding()
                    }
                    .background(viewModel.activeTool == .crop ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                    .shadow(radius: viewModel.activeTool == .crop ? 2 : 0)
                    
                    Button(action: { viewModel.setActiveTool(.adjust) }) {
                        VStack(spacing: 5) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 20))
                            Text("Adjust")
                                .font(.system(size: 12))
                        }
                        .frame(width: 80, height: 60)
                        .padding()
                    }
                    .background(viewModel.activeTool == .adjust ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                    .shadow(radius: viewModel.activeTool == .adjust ? 2 : 0)
                    
                    Button(action: { viewModel.setActiveTool(.filters) }) {
                        VStack(spacing: 5) {
                            Image(systemName: "camera.filters")
                                .font(.system(size: 20))
                            Text("Filters")
                                .font(.system(size: 12))
                        }
                        .frame(width: 80, height: 60)
                        .padding()
                    }
                    .background(viewModel.activeTool == .filters ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                    .shadow(radius: viewModel.activeTool == .filters ? 2 : 0)
                }
                .padding()
                .background(
                    Color.clear
                        .background(.ultraThinMaterial)
                )
                
                // 中间预览区域
                VStack {
                    GeometryReader { geometry in
                        ZStack {
                            Image(nsImage: viewModel.getEditedNSImage())
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.brightness)
                            
                            if viewModel.activeTool == .crop && viewModel.isCropping {
                                // 裁剪框覆盖层
                                Color.black.opacity(0.5)
                                    .mask(
                                        Rectangle()
                                            .path(in: CGRect(x: 50, y: 50, width: geometry.size.width - 100, height: geometry.size.height - 100))

                                    )
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.isCropping)
                                
                                // 裁剪框
                                Rectangle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: geometry.size.width - 100, height: geometry.size.height - 100)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.isCropping)
                                
                                // 裁剪控制按钮
                                HStack {
                                    Spacer()
                                    Button(action: { viewModel.cropImage(rect: CGRect(x: 0, y: 0, width: viewModel.getEditedImage().extent.width, height: viewModel.getEditedImage().extent.height)) }) {
                                        Text("Apply")
                                            .padding(10)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                            .shadow(radius: 2)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    Color.clear
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                )
                
                // 右侧参数调节
                VStack {
                    if viewModel.activeTool == .adjust {
                        Text("Brightness")
                        Slider(value: $viewModel.brightness, in: -1.0...1.0)
                        
                        Text("Contrast")
                        Slider(value: $viewModel.contrast, in: 0.0...2.0)
                        
                        Text("Saturation")
                        Slider(value: $viewModel.saturation, in: 0.0...2.0)
                        
                        Text("Sharpness")
                        Slider(value: $viewModel.sharpness, in: -1.0...1.0)
                        
                        Text("Clarity")
                        Slider(value: $viewModel.clarity, in: -1.0...1.0)
                    } else if viewModel.activeTool == .filters {
                        Text("Filters")
                        // 常用滤镜选项
                        VStack {
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectNoir") }) {
                                Text("Black & White")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectSepia") }) {
                                Text("Sepia")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectVintage") }) {
                                Text("Vintage")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectInstant") }) {
                                Text("Instant")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectProcess") }) {
                                Text("Process")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectTonal") }) {
                                Text("Tonal")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button(action: { viewModel.applyFilter(filterName: "CIPhotoEffectTransfer") }) {
                                Text("Transfer")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    } else if viewModel.activeTool == .crop {
                        Text("Crop")
                        Text("Use the crop tool to adjust the image")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(
                    Color.clear
                        .background(.ultraThinMaterial)
                )
            }
        }
        .frame(minWidth: 1000, minHeight: 800)
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}
