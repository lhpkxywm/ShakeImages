//
//  DataFileManager.swift
//  ShakeImage
//
//  Created by MacMini on 1/30/23.
//

import Foundation

class DataFileManager {
    
    static func saveUserData(filePath: String) {
        let userData = try? NSKeyedArchiver.archivedData(withRootObject: UserInfoModel.shared, requiringSecureCoding: true)
        try? userData?.write(to: URL(fileURLWithPath: filePath))
    }
    
    static func loadUserData(filePath: String) {
        if let userData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            if let userModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userData) as? UserInfoModel {
                UserInfoModel.shared = userModel
            }
        }
    }
}
