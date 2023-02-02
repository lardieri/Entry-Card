//
//  Settings View.swift
//  Entry Card
//

import SwiftUI
import SFSymbolEnum

struct SettingsView: View {
    @State var settings: Settings

    var body: some View {
        TabView {
            PicturesTab()
                .tabItem {
                    Image(systemName: .photo)
                    Text("Pictures")
                }
                .tag(1)

            SettingsTab()
                .tabItem {
                    Image(systemName: .gearshape)
                    Text("Settings")
                }
                .tag(2)

            AboutTab()
                .tabItem {
                    Image(systemName: .infoCircle)
                    Text("About")
                }
                .tag(3)
        }
        .environmentObject(settings)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        SettingsView(settings: settings)
    }
}
