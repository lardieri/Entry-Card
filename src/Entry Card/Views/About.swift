//
//  About.swift
//  Entry Card
//

import SwiftUI

struct About: View {
    var body: some View {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let version = " Release " + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        let copyright = Bundle.main.infoDictionary!["NSHumanReadableCopyright"] as! String

        VStack(alignment: .center) {
            Spacer()

            Text(appName)
                .font(.largeTitle)

            Spacer(minLength: 65.0)

            Text(version)
                .font(.subheadline)

            Spacer(minLength: 65.0)

            Text(copyright)

            Spacer()
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
