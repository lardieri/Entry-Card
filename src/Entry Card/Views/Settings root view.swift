//
//  Settings root view.swift
//  Entry Card
//

import SwiftUI
import SFSymbolEnum

struct SettingsRootView: View {
    @State var settings: Settings
    @State var pictures: Pictures

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
        .environmentObject(pictures)
    }
}

struct SettingsRootView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        let pictures = Pictures()
        SettingsRootView(settings: settings, pictures: pictures)
    }
}
