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
