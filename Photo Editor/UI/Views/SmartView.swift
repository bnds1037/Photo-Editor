import SwiftUI

struct SmartView: View {
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var viewModel: SmartViewModel
    @State private var searchText: String = ""
    
    init() {
        let dataManager = DataManager()
        self._viewModel = StateObject(wrappedValue: SmartViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Text("Smart Features")
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 智能搜索
            VStack {
                HStack {
                    TextField("Search photos...", text: $searchText, onCommit: { viewModel.searchPhotos(keyword: searchText) })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 400)
                    Button(action: { viewModel.searchPhotos(keyword: searchText) }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding()
                
                // 搜索结果
                if !viewModel.searchResults.isEmpty {
                    Text("Search Results: \(viewModel.searchResults.count) photos")
                        .font(.headline)
                        .padding(.top, 10)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))], spacing: 20) {
                            ForEach(viewModel.searchResults) { photo in
                                PhotoCard(photo: photo)
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding()
            .background(
                Color.clear
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .padding()
            
            // 智能功能选项
            HStack(spacing: 20) {
                Button(action: { viewModel.detectDuplicates() }) {
                    VStack {
                        Image(systemName: "circle.lefthalf.filled")
                            .font(.largeTitle)
                        Text("Find Duplicates")
                    }
                    .padding()
                    .background(
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
                }
                
                Button(action: {}) {
                    VStack {
                        Image(systemName: "person.2")
                            .font(.largeTitle)
                        Text("Face Recognition")
                    }
                    .padding()
                    .background(
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
                }
                
                Button(action: {}) {
                    VStack {
                        Image(systemName: "location")
                            .font(.largeTitle)
                        Text("Scene Classification")
                    }
                    .padding()
                    .background(
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
                }
            }
            .padding()
            
            // 智能功能结果
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if !viewModel.duplicatePhotos.isEmpty {
                VStack {
                    Text("Found \(viewModel.duplicatePhotos.count) duplicate photo pairs")
                        .font(.headline)
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(0..<viewModel.duplicatePhotos.count, id: \.self) {index in
                                let (photo1, photo2) = viewModel.duplicatePhotos[index]
                                HStack {
                                    PhotoThumbnail(photo: photo1)
                                    PhotoThumbnail(photo: photo2)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                .background(
                    Color.clear
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                )
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

struct PhotoCard: View {
    let photo: PhotoModel
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 220, height: 180)
                .overlay {
                    Text("Photo")
                        .foregroundColor(.gray)
                }
            Text(photo.createDate.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .padding(.top, 8)
        }
        .background(
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .padding(4)
    }
}

struct PhotoThumbnail: View {
    let photo: PhotoModel
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 120, height: 100)
                .overlay {
                    Text("Photo")
                        .foregroundColor(.gray)
                }
        }
    }
}
