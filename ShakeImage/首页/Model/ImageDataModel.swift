//
//  ImageDataModel.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import Foundation
import HandyJSON

struct ImageDataModel: HandyJSON {
    var imageId = 0
    var imageUrl = ""
    var imgType = 0
    var userId = ""
    var favorIdArr = ""
    var shieldArr = ""
    var isFavor = false
}
