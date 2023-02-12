//
//  SettingsHostingViewController.swift
//  Entry Card
//

import UIKit
import SwiftUI

class SettingsHostingViewController: UIHostingController<SettingsRootView> {

    required init?(coder aDecoder: NSCoder) {
        let settings = Settings()
        let rootView = SettingsRootView(settings: settings)

        super.init(coder: aDecoder, rootView: rootView)
    }

}
