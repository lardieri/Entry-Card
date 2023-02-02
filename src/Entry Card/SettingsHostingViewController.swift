//
//  SettingsHostingViewController.swift
//  Entry Card
//

import UIKit
import SwiftUI

class SettingsHostingViewController: UIHostingController<SettingsView> {

    required init?(coder aDecoder: NSCoder) {
        let settings = Settings()
        let rootView = SettingsView(settings: settings)

        super.init(coder: aDecoder, rootView: rootView)
    }

}
