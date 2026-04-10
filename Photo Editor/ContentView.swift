//
//  ContentView.swift
//  Photo Editor
//
//  Created by 刘明浩 on 2026/4/8.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .photos
    
    enum Tab {
        case photos
        case albums
        case dashboard
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
                .background(selectedTab == .photos ? Color.clear : Color.clear)
                
                Divider()
                
                // 主要选项
                VStack(alignment: .leading, spacing: 0) {
                    TabItem(title: "Photos", systemImage: "photo", isSelected: selectedTab == .photos) {
                        selectedTab = .photos
                    }
                    
                    TabItem(title: "Albums", systemImage: "folder", isSelected: selectedTab == .albums) {
                        selectedTab = .albums
                    }
                    
                    TabItem(title: "Dashboard", systemImage: "chart.bar", isSelected: selectedTab == .dashboard) {
                        selectedTab = .dashboard
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(width: 200)
            .background(Color(.windowBackgroundColor))
            
            // 主内容区域
            VStack {
                switch selectedTab {
                case .photos:
                    PhotosView()
                case .albums:
                    AlbumsView()
                case .dashboard:
                    DashboardView()
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
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
    var body: some View {
        VStack {
            Text("Photos")
                .font(.largeTitle)
            Text("Photo browsing interface")
        }
        .padding()
    }
}

// 相册视图
struct AlbumsView: View {
    var body: some View {
        VStack {
            Text("Albums")
                .font(.largeTitle)
            Text("Album management interface")
        }
        .padding()
    }
}

// 仪表板视图
struct DashboardView: View {
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
            Text("Dashboard interface")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
