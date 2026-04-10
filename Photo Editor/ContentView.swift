//
//  ContentView.swift
//  Photo Editor
//
//  Created by 刘明浩 on 2026/4/8.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @StateObject private var mainViewModel: MainViewModel
    @StateObject private var albumViewModel: AlbumViewModel
    @StateObject private var smartViewModel: SmartViewModel
    
    @State private var selectedTab: Tab = .photos
    
    enum Tab {
        case photos
        case albums
        case dashboard
        case moment
    }
    
    init() {
        let dataManager = DataManager()
        self._mainViewModel = StateObject(wrappedValue: MainViewModel(dataManager: dataManager))
        self._albumViewModel = StateObject(wrappedValue: AlbumViewModel(dataManager: dataManager))
        self._smartViewModel = StateObject(wrappedValue: SmartViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        HStack {
            // 左侧目录栏
            VStack(alignment: .leading, spacing: 0) {
                // 应用标题
                HStack {
                    Image(systemName: "photo")
                    Text("PhotoMaster")
                        .font(.headline)
                }
                .padding()
                
                Divider()
                
                // 主要选项
                VStack(alignment: .leading, spacing: 0) {
                    TabItem(title: "Photos", systemImage: "photo", isSelected: selectedTab == .photos) {
                        selectedTab = .photos
                    }
                    
                    TabItem(title: "Albums", systemImage: "folder", isSelected: selectedTab == .albums) {
                        selectedTab = .albums
                    }
                    
                    TabItem(title: "Moment", systemImage: "star", isSelected: selectedTab == .moment) {
                        selectedTab = .moment
                    }
                    
                    TabItem(title: "Dashboard", systemImage: "chart.bar", isSelected: selectedTab == .dashboard) {
                        selectedTab = .dashboard
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(width: 200)
            .background(
                // macOS 26 Liquid Glass 效果
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 主内容区域
            VStack {
                switch selectedTab {
                case .photos:
                    PhotosView(viewModel: mainViewModel)
                case .albums:
                    AlbumsView(viewModel: albumViewModel)
                case .moment:
                    MomentView()
                case .dashboard:
                    DashboardView(viewModel: smartViewModel)
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(
            // 主背景也使用 Liquid Glass 效果
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}

// 自定义TabItem视图，包含毛玻璃效果
struct TabItem: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    if isSelected {
                        // 毛玻璃效果
                        if #available(macOS 10.15, *) {
                            VisualEffectView(material: .selection, blendingMode: .withinWindow)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Color.accentColor.opacity(0.2)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            )
            .foregroundColor(isSelected ? .accentColor : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 视觉效果视图，用于实现毛玻璃效果
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// 照片视图
struct PhotosView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Text("Photos")
                    .font(.headline)
                Spacer()
                Button(action: { viewModel.toggleView() }) {
                    Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.2x2")
                }
                TextField("Search", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
            }
            .padding()
            .background(
                // 工具栏使用 Liquid Glass 效果
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 照片网格
            ScrollView {
                if viewModel.isGridView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))], spacing: 20) {
                        ForEach(viewModel.searchPhotos()) { photo in
                            PhotoCard(photo: photo)
                        }
                    }
                } else {
                    VStack(spacing: 10) {
                        ForEach(viewModel.searchPhotos()) { photo in
                            PhotoRow(photo: photo)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// 照片卡片
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
            // 卡片使用 Liquid Glass 效果
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .padding(4)
    }
}

// 照片行
struct PhotoRow: View {
    let photo: PhotoModel
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 60)
                .overlay {
                    Text("Photo")
                        .foregroundColor(.gray)
                }
            VStack(alignment: .leading) {
                Text(photo.createDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.body)
                if let location = photo.location {
                    Text(location)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text(photo.tags.joined(separator: ", "))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(
            // 行使用 Liquid Glass 效果
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        )
    }
}

// 相册视图
struct AlbumsView: View {
    @ObservedObject var viewModel: AlbumViewModel
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Text("Albums")
                    .font(.headline)
                Spacer()
                Button(action: { viewModel.createAlbum(name: "New Album") }) {
                    Image(systemName: "plus")
                }
            }
            .padding()
            .background(
                // 工具栏使用 Liquid Glass 效果
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
    }
}

// 相册卡片
struct AlbumCard: View {
    let album: AlbumModel
    let viewModel: AlbumViewModel
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 220, height: 180)
                .overlay {
                    Text(album.name)
                        .foregroundColor(.gray)
                }
            Text(album.name)
                .font(.caption)
                .padding(.top, 8)
            Text("\(viewModel.getPhotosInAlbum(albumID: album.id).count) photos")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .background(
            // 卡片使用 Liquid Glass 效果
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .padding(4)
        .onTapGesture {
            viewModel.selectAlbum(album: album)
        }
    }
}

// 仪表板视图
struct DashboardView: View {
    @ObservedObject var viewModel: SmartViewModel
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Text("Dashboard")
                    .font(.headline)
                Spacer()
                Button(action: { viewModel.detectDuplicates() }) {
                    Text("Find Duplicates")
                }
            }
            .padding()
            .background(
                // 工具栏使用 Liquid Glass 效果
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 仪表板内容
            ScrollView {
                VStack(spacing: 20) {
                    // 统计卡片
                    HStack(spacing: 20) {
                        StatCard(title: "Total Photos", value: "1,248")
                        StatCard(title: "Total Albums", value: "24")
                        StatCard(title: "Favorites", value: "156")
                    }
                    
                    // 最近活动
                    VStack(alignment: .leading) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.bottom, 10)
                        ForEach(1...5, id: \.self) {
                            ActivityItem(number: $0)
                        }
                    }
                    .padding()
                    .background(
                        // 使用 Liquid Glass 效果
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
                    
                    // 智能功能
                    VStack(alignment: .leading) {
                        Text("Smart Features")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else if !viewModel.duplicatePhotos.isEmpty {
                            Text("Found \(viewModel.duplicatePhotos.count) duplicate photo pairs")
                                .font(.body)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding()
                    .background(
                        // 使用 Liquid Glass 效果
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
                }
                .padding()
            }
        }
    }
}

// 统计卡片
struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            // 卡片使用 Liquid Glass 效果
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
}

// 活动项
struct ActivityItem: View {
    let number: Int
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.green.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "photo")
                        .foregroundColor(.green)
                }
            VStack(alignment: .leading) {
                Text("Added photo \(number)")
                    .font(.body)
                Text("Today, 10:\(number * 10):00 AM")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Moment视图 - 随机展示收藏的照片
struct MomentView: View {
    @State private var currentPhotoIndex = 0
    @State private var favoritesPhotos = [1, 2, 3, 5, 8, 10, 12] // 模拟收藏的照片索引
    
    var body: some View {
        VStack {
            // 顶部工具栏
            HStack {
                Text("Moment")
                    .font(.headline)
                Spacer()
                Button(action: { nextPhoto() }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()
            .background(
                // 工具栏使用 Liquid Glass 效果
                Color.clear
                    .background(.ultraThinMaterial)
            )
            
            // 照片展示区域
            Spacer()
            
            // 大尺寸照片展示
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 500, height: 350)
                    .overlay {
                        Text("Favorite Photo \(favoritesPhotos[currentPhotoIndex])")
                            .foregroundColor(.gray)
                    }
                Text("Favorite Photo \(favoritesPhotos[currentPhotoIndex])")
                    .font(.headline)
                    .padding(.top, 20)
                Text("Randomly selected from your favorites")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .background(
                // 使用 Liquid Glass 效果
                Color.clear
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            )
            .padding(20)
            
            Spacer()
            
            // 操作按钮
            HStack(spacing: 20) {
                Button(action: { previousPhoto() }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Previous")
                    }
                    .padding()
                    .background(
                        // 使用 Liquid Glass 效果
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
                }
                
                Button(action: { nextPhoto() }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .background(
                        // 使用 Liquid Glass 效果
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
                }
                
                Button(action: { shufflePhotos() }) {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("Shuffle")
                    }
                    .padding()
                    .background(
                        // 使用 Liquid Glass 效果
                        Color.clear
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
                }
            }
            .padding()
        }
        .onAppear {
            // 初始化时随机选择一张照片
            currentPhotoIndex = Int.random(in: 0..<favoritesPhotos.count)
        }
    }
    
    // 显示下一张照片
    func nextPhoto() {
        currentPhotoIndex = (currentPhotoIndex + 1) % favoritesPhotos.count
    }
    
    // 显示上一张照片
    func previousPhoto() {
        currentPhotoIndex = (currentPhotoIndex - 1 + favoritesPhotos.count) % favoritesPhotos.count
    }
    
    // 随机打乱照片顺序
    func shufflePhotos() {
        favoritesPhotos.shuffle()
        currentPhotoIndex = 0
    }
}

#Preview {
    ContentView()
}
