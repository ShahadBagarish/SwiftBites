import SwiftUI
import SwiftData

@main
@MainActor
struct SwiftBitesApp: App {
    
  var body: some Scene {
    WindowGroup {
      ContentView()
            .modelContainer(modelContainer)
    }
  }
}
