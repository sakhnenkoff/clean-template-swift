import SwiftUI

public struct LoadingView: View {
    let message: String?
    let style: LoadingStyle

    public init(
        message: String? = nil,
        style: LoadingStyle = .default
    ) {
        self.message = message
        self.style = style
    }

    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(style.scale)
                .tint(style.tintColor)

            if let message = message {
                Text(message)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .background(style.backgroundColor)
        .cornerRadius(16)
    }
}

public enum LoadingStyle {
    case `default`
    case overlay
    case inline

    var scale: CGFloat {
        switch self {
        case .default: return 1.5
        case .overlay: return 2.0
        case .inline: return 1.0
        }
    }

    var backgroundColor: Color {
        switch self {
        case .default: return .backgroundSecondary
        case .overlay: return .black.opacity(0.7)
        case .inline: return .clear
        }
    }

    var tintColor: Color {
        switch self {
        case .default, .inline: return .primary
        case .overlay: return .white
        }
    }
}

public extension View {
    func loading(_ isLoading: Bool, message: String? = nil) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    LoadingView(message: message, style: .overlay)
                }
            }
        }
    }
}

#Preview("Default Loading") {
    LoadingView(message: "Loading...")
}

#Preview("Overlay Loading") {
    LoadingView(message: "Please wait...", style: .overlay)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
}

#Preview("Inline Loading") {
    HStack {
        Text("Processing")
        LoadingView(style: .inline)
    }
}

#Preview("Loading Modifier") {
    Text("Content underneath")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .loading(true, message: "Loading data...")
}
