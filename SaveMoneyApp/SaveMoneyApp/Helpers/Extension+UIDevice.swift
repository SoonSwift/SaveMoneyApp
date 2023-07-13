//
//  Extension+UIDevice.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 13/07/2023.
//

import UIKit

extension UIDevice {
    struct DeviceModel: Decodable {
        let identifier: String
        let model: String
        
        static var all: [DeviceModel] {
            Bundle.main.getData(from: "DeviceModels.json")?.decode() ?? []
        }
    }
    var modelName: String {
#if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
#else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier , element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
#endif
        return DeviceModel.all.first {$0.identifier == identifier}?.model ?? identifier
    }
}
