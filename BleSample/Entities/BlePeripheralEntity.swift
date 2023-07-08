//
//  BlePeripheralEntity.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import CoreBluetooth

struct ServiceUUIDKeys: Identifiable {
    let id: UUID
    let key: String
}

struct BlePeripheralEntity: Identifiable {
    
    let id: String
    let name: String
    let peripheral: CBPeripheral
    let localName: String
    let isConnectable: Bool
    let serviceUUIDKey: [ServiceUUIDKeys]
    let rssi: Int
}
