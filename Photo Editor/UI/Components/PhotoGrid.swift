import SwiftUI

struct PhotoGridView: View {
    let photos: [PhotoModel]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))], spacing: 20) {
                ForEach(photos) { photo in
                    PhotoCard(photo: photo)
                }
            }
            .padding()
        }
    }
}

struct PhotoTimelineView: View {
    let photos: [PhotoModel]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(photos) { photo in
                    PhotoRow(photo: photo)
                }
            }
            .padding()
        }
    }
}
