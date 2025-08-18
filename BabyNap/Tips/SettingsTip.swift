//
//  SettingsTip.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import Foundation
import TipKit

struct SettingsTip: Tip {
    var title: Text {
        Text("settings.tip.title")
    }
    
    var message: Text? {
        Text("settings.tip.message")
    }
    
    var image: Image? {
        Image(systemName: "gear")
    }
}
