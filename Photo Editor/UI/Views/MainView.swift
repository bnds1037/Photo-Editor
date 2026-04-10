import SwiftUI

struct MainView: View {
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var viewModel: MainViewModel
    
    init() {
        let dataManager = DataManager()
        self._viewModel = StateObject(wrappedValue: MainViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        VStack {
            // 顶部工具栏
            ToolbarView(viewModel: viewModel)
            
            // 主内容区域
            if viewModel.isGridView {
                PhotoGridView(photos: viewModel.searchPhotos())
            } else {
                PhotoTimelineView(photos: viewModel.searchPhotos())
            }
            
            // 底部栏
            BottomBarView(photoCount: viewModel.searchPhotos().count)
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}
