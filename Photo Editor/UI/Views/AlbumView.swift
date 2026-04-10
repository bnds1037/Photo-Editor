import SwiftUI

struct AlbumView: View {
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var viewModel: AlbumViewModel
    
    init() {
        let dataManager = DataManager()
        self._viewModel = StateObject(wrappedValue: AlbumViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Text("Albums")
                    .font(.headline)
                Spacer()
                Button(action: { viewModel.createAlbum(name: "New Album") }) {
                    Image(systemName: "plus")
                    Text("New Album")
                }
            }
            .padding()
            .background(
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 相册网格
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))], spacing: 20) {
                    ForEach(viewModel.albums) { album in
                        AlbumCard(album: album, viewModel: viewModel)
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}

