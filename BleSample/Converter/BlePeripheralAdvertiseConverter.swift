//
//  BlePeripheralAdvertiseConverter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/30.
//

import Foundation

struct BlePeripheralAdvertiseConverter {
    
    static func convertServiceIdDicToObject(target: [String]) -> [ServiceUUIDKeys] {
        
        return target.map { ServiceUUIDKeys(id: UUID(), key: $0) }
    }
}
