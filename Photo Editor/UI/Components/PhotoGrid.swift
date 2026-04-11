import SwiftUI

struct PhotoGridView: View {
    let photos: [PhotoModel]
    let onToggleFavorite: (PhotoModel) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))], spacing: 20) {
                ForEach(photos) { photo in
                    PhotoCard(photo: photo, onToggleFavorite: onToggleFavorite)
                }
            }
            .padding()
        }
    }
}

struct PhotoTimelineView: View {
    let photos: [PhotoModel]
    let onToggleFavorite: (PhotoModel) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(photos) { photo in
                    PhotoRow(photo: photo, onToggleFavorite: onToggleFavorite)
                }
            }
            .padding()
        }
    }
}
