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
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        )
    }
}
