import SwiftUI

struct ToolbarView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            // 视图切换
            Button(action: { viewModel.toggleView() }) {
                Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.2x2")
                Text(viewModel.isGridView ? "Timeline" : "Grid")
            }
            .padding()
            
            Spacer()
            
            // 搜索框
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            // 筛选按钮
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
            }
            .padding()
            
            // 导入按钮
            Button(action: {}) {
                Image(systemName: "plus")
                Text("Import")
            }
            .padding()
            
            // 拍照按钮
            Button(action: {}) {
                Image(systemName: "camera")
                Text("Take Photo")
            }
            .padding()
        }
        .padding()
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}

struct BottomBarView: View {
    let photoCount: Int
    
    var body: some View {
        HStack {
            Text("\(photoCount) photos")
            Spacer()
            Button(action: {}) {
                Text("Batch Operations")
            }
        }
        .padding()
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}
