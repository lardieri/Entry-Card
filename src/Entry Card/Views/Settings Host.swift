//
//  Settings Host.swift
//  Entry Card
//

import SwiftUI

struct SettingsHost: View {
    var body: some View {
        TabView {
            PicturesTab()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Pictures")
                }
                .tag(1)

            SettingsTab()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(2)

            AboutTab()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
                .tag(3)
        }
    }
}

struct SettingsHost_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHost()
    }
}
