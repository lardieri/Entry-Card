//
//  Third Party - UIView borders.swift
//  Entry Card
//

import SwiftUI

struct ThirdParty_UIViewBorders: View {
    var body: some View {
        GroupBox("@ IBInspectable Borders") {
            Text("""
            by Mike Woelmer

            © 2017 Atomic Object LLC

            https://spin.atomicobject.com/2017/07/18/swift-interface-builder
            """)
                .font(.caption)
        }
    }
}

struct ThirdParty_UIViewBorders_Previews: PreviewProvider {
    static var previews: some View {
        ThirdParty_UIViewBorders()
    }
}
