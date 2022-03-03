//
//  Extension.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let qiNiuFileHost = "http://kokofiles.waityousell.com/"

var Color_Theme: UIColor {
    return UIColor(named: "LightBlue") ?? .systemBlue
}

func isIPhoneXSeries() -> Bool {
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
        return false
    }
    return UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
}
