//
//  SettingsHostingViewController.swift
//  Entry Card
//

import UIKit
import SwiftUI

class SettingsHostingViewController: UIHostingController<SettingsRootView> {

    required init?(coder aDecoder: NSCoder) {
        let settings = Settings()
        let pictures = Pictures()
        let rootView = SettingsRootView(settings: settings, pictures: pictures)

        super.init(coder: aDecoder, rootView: rootView)
    }

}
