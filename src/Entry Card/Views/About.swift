//
//  About.swift
//  Entry Card
//

import SwiftUI

struct About: View {
    var body: some View {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let version = "Release " + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        let copyright = Bundle.main.infoDictionary!["NSHumanReadableCopyright"] as! String

        VStack(alignment: .center) {
            Spacer(minLength: 30.0)

            Text(appName)
                .font(.largeTitle)

            Spacer(minLength: 70.0)

            Text(version)
                .font(.subheadline)

            Spacer(minLength: 70.0)

            Text(copyright)

            Spacer(minLength: 100.0)
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
