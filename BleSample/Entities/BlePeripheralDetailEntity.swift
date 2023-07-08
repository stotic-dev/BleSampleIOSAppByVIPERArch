//
//  BlePeripheralDetailEntity.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/25.
//

import Foundation

struct BlePeripheralDetailEntity: Identifiable {
    
    let id: String
    let name: String
    let isConnectable: Bool
    let localName: String
    let serviceUUIDKey: [ServiceUUIDKeys]
    let rssi: Int
}
