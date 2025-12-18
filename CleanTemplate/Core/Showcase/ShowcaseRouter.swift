//
//  ShowcaseRouter.swift
//  CleanTemplate
//
//

import SwiftUI

@MainActor
protocol ShowcaseRouter: GlobalRouter {
    func showDemoPushScreen()
    func showDemoSheet()
    func showDemoFullScreen()
    func showCustomButtonsAlert()
    func switchToOnboardingModule()
}

extension CoreRouter: ShowcaseRouter {

    func showDemoPushScreen() {
        router.showScreen(.push) { _ in
            DemoDestinationView(
                title: "Push Navigation",
                subtitle: "Arrived via .push transition",
                systemImage: "arrow.right.square.fill"
            )
        }
    }

    func showDemoSheet() {
        router.showScreen(.sheet) { _ in
            DemoDestinationView(
                title: "Sheet Presentation",
                subtitle: "Arrived via .sheet transition",
                systemImage: "rectangle.bottomhalf.inset.filled"
            )
        }
    }

    func showDemoFullScreen() {
        router.showScreen(.fullScreenCover) { _ in
            DemoDestinationView(
                title: "Full Screen Cover",
                subtitle: "Arrived via .fullScreenCover transition",
                systemImage: "rectangle.inset.filled"
            )
        }
    }

    func showCustomButtonsAlert() {
        showAlert(.alert, title: "Custom Alert", subtitle: "Choose an action") {
            AnyView(
                Group {
                    Button("Option A") { }
                    Button("Option B") { }
                    Button("Cancel", role: .cancel) { }
                }
            )
        }
    }
}

// MARK: - Demo Destination View

private struct DemoDestinationView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text(title)
                .font(.titleLarge())

            Text(subtitle)
                .font(.bodyMedium())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Text("Dismiss")
                .font(.buttonLarge())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 24)
                .anyButton(.press) {
                    dismiss()
                }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    DemoDestinationView(
        title: "Demo Screen",
        subtitle: "This is a demo destination",
        systemImage: "star.fill"
    )
}
