import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct EditView: View {
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var viewModel: EditViewModel
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        let ciImage = CIImage(image: image) ?? CIImage()
        let dataManager = DataManager()
        self._viewModel = StateObject(wrappedValue: EditViewModel(dataManager: dataManager, image: ciImage))
    }
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Undo")
                }
                .padding()
                
                Button(action: {}) {
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
                
                Button(action: {}) {
                    Text("Save")
                }
                .padding()
                
                Button(action: {}) {
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
                VStack {
                    Button(action: {}) {
                        Image(systemName: "crop")
                        Text("Crop")
                    }
                    .padding()
                    
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                        Text("Adjust")
                    }
                    .padding()
                    
                    Button(action: {}) {
                        Image(systemName: "camera.filters")
                        Text("Filters")
                    }
                    .padding()
                }
                .padding()
                .background(
                    Color.clear
                        .background(.ultraThinMaterial)
                )
                
                // 中间预览区域
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()
                
                // 右侧参数调节
                VStack {
                    Text("Brightness")
                    Slider(value: $viewModel.brightness, in: -1.0...1.0)
                    
                    Text("Contrast")
                    Slider(value: $viewModel.contrast, in: 0.0...2.0)
                    
                    Text("Saturation")
                    Slider(value: $viewModel.saturation, in: 0.0...2.0)
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
