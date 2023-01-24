//
//  Third Party - UIBarButtonItem visibility.swift
//  Entry Card
//

import SwiftUI

struct ThirdParty_UIBarButtonItem: View {
    var body: some View {
        GroupBox("UIBarButtonItem Extension") {
            Text("""
            by Mike Woelmer

            © 2018 Atomic Object LLC

            https://spin.atomicobject.com/2018/03/15/extend-uibarbuttonitem
            """)
                .font(.caption)
        }
    }
}

struct ThirdParty_UIBarButtonItem_Previews: PreviewProvider {
    static var previews: some View {
        ThirdParty_UIBarButtonItem()
    }
}
