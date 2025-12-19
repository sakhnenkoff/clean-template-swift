import SwiftUI
import SwiftfulUI
import DesignSystem

struct HomeDelegate {
    var eventParameters: [String: Any]? {
        nil
    }
}

struct HomeView: View {
    
    @State var presenter: HomePresenter
    let delegate: HomeDelegate
    
    private var showDevSettingsButton: Bool {
        #if DEV || MOCK
        return true
        #else
        return false
        #endif
    }

    var body: some View {
        List {
            Text("Hello, World!")
        }
        .navigationTitle("Home")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                if showDevSettingsButton {
                    devSettingsButton
                }
            }
        })
        .onAppear {
            presenter.onViewAppear(delegate: delegate)
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
        .onOpenURL { url in
            presenter.handleDeepLink(url: url)
        }
        .onNotificationRecieved(name: .pushNotification) { notification in
            presenter.handlePushNotificationRecieved(notification: notification)
        }
    }
    
    private var devSettingsButton: some View {
        Text("DEV")
            .foregroundStyle(Color.textOnPrimary)
            .font(.callout)
            .bold()
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.xs)
            .background(Color.themeAccent)
            .cornerRadius(DSSpacing.smd)
            .fixedSize(horizontal: true, vertical: false)
            .anyButton(.press) {
                presenter.onDevSettingsPressed()
            }
    }

}

#Preview {
    PreviewRouter { router in
        DevPreview.builder.homeView(router: router, delegate: HomeDelegate())
    }
}

extension CoreBuilder {
    
    func homeView(router: AnyRouter, delegate: HomeDelegate) -> some View {
        HomeView(
            presenter: HomePresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            ),
            delegate: delegate
        )
    }
    
}

extension CoreRouter {
    
    func showHomeView(delegate: HomeDelegate) {
        router.showScreen(.push) { router in
            builder.homeView(router: router, delegate: delegate)
        }
    }
    
}
