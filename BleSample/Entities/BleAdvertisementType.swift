//
//  BleAdvertisementType.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/27.
//

import Foundation
import CoreBluetooth

enum BleAdvertisementType {
    
    case localName
    case connectable
    case serviceUUIDKey
    
    func getName() -> String {
        switch self{
            
        case .localName:
            
            return CBAdvertisementDataLocalNameKey
        case .connectable:
            
            return CBAdvertisementDataIsConnectable
        case .serviceUUIDKey:
            
            return CBAdvertisementDataServiceUUIDsKey
        }
    }
}
