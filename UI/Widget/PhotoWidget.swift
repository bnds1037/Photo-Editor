import SwiftUI
import WidgetKit

struct PhotoWidget: Widget {
    let kind: String = "PhotoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PhotoWidgetProvider()) {
            PhotoWidgetView(entry: $0)
        }
        .configurationDisplayName("Photo Master Widget")
        .description("Show recent photos and quick actions")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct PhotoWidgetView: View {
    var entry: PhotoWidgetEntry
    
    var body: some View {
        switch entry.family {
        case .systemSmall:
            SmallPhotoWidgetView(entry: entry)
        case .systemMedium:
            MediumPhotoWidgetView(entry: entry)
        case .systemLarge:
            LargePhotoWidgetView(entry: entry)
        default:
            SmallPhotoWidgetView(entry: entry)
        }
    }
}

struct SmallPhotoWidgetView: View {
    var entry: PhotoWidgetEntry
    
    var body: some View {
        VStack {
            Text("Photo Master")
                .font(.headline)
            Spacer()
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay {
                    Text("Photo")
                        .foregroundColor(.gray)
                }
            Spacer()
            HStack {
                Button(action: {})
                {
                    Image(systemName: "camera")
                }
                Spacer()
                Button(action: {})
                {
                    Image(systemName: "photo")
                }
            }
        }
        .padding()
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}

struct MediumPhotoWidgetView: View {
    var entry: PhotoWidgetEntry
    
    var body: some View {
        VStack {
            Text("Photo Master")
                .font(.headline)
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 100)
                    .overlay {
                        Text("Photo 1")
                            .foregroundColor(.gray)
                    }
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 100)
                    .overlay {
                        Text("Photo 2")
                            .foregroundColor(.gray)
                    }
            }
            HStack {
                Button(action: {})
                {
                    Image(systemName: "camera")
                    Text("Take Photo")
                }
                Spacer()
                Button(action: {})
                {
                    Image(systemName: "photo")
                    Text("Open Album")
                }
            }
        }
        .padding()
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}

struct LargePhotoWidgetView: View {
    var entry: PhotoWidgetEntry
    
    var body: some View {
        VStack {
            Text("Photo Master")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(1..<5, id: \.self) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay {
                            Text("Photo \($0)")
                                .foregroundColor(.gray)
                        }
                }
            }
            HStack {
                Button(action: {})
                {
                    Image(systemName: "camera")
                    Text("Take Photo")
                }
                Spacer()
                Button(action: {})
                {
                    Image(systemName: "photo")
                    Text("Open Album")
                }
                Spacer()
                Button(action: {})
                {
                    Image(systemName: "star")
                    Text("Favorites")
                }
            }
        }
        .padding()
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
}

struct PhotoWidgetEntry: TimelineEntry {
    let date: Date
    let family: WidgetFamily
}

struct PhotoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> PhotoWidgetEntry {
        PhotoWidgetEntry(date: Date(), family: context.family)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PhotoWidgetEntry) -> ()) {
        let entry = PhotoWidgetEntry(date: Date(), family: context.family)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoWidgetEntry>) -> ()) {
        let entry = PhotoWidgetEntry(date: Date(), family: context.family)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
