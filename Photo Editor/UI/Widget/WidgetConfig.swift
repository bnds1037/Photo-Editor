import SwiftUI
import WidgetKit

struct PhotoMasterWidgets: WidgetBundle {
    var body: some Widget {
        PhotoWidget()
    }
}

struct WidgetConfig {
    static let widgetKind = "PhotoWidget"
    static let widgetDisplayName = "Photo Master Widget"
    static let widgetDescription = "Show recent photos and quick actions"
    
    static func openApp(action: String) {
        // 实现打开应用的逻辑
        print("Opening app with action: \(action)")
    }
    
    static func getRecentPhotos() -> [PhotoModel] {
        // 实现获取最近照片的逻辑
        let dataManager = DataManager()
        return dataManager.photos.sorted(by: { $0.createDate > $1.createDate }).prefix(4).map { $0 }
    }
}
