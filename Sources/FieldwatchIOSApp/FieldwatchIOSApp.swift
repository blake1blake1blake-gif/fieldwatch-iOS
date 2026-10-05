import SwiftUI

@main
struct FieldwatchIOSApp: App {
    @StateObject private var viewModel = FieldwatchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        TabView {
            LiveView(viewModel: viewModel)
                .tabItem {
                    Label("Live", systemImage: "dot.radiowaves.left.and.right")
                }

            ReportsView(viewModel: viewModel)
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(.cyan)
    }
}
