//
//  Settings Host.swift
//  Entry Card
//

import SwiftUI

struct Settings_Host: View {
    var body: some View {
        TabView {
            Text("Pictures")
                .tabItem {
                    Image(systemName: "photo")
                    Text("Pictures")
                }
                .tag(1)

            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(2)

            Text("About")
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
                .tag(3)
        }
    }
}

struct Settings_Host_Previews: PreviewProvider {
    static var previews: some View {
        Settings_Host()
    }
}
