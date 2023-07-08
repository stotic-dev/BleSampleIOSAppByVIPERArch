//
//  BlePeripheralDetailViewModel.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/25.
//

import Foundation
import CoreBluetooth
import Combine

class BlePeripheralDetailViewModel: ObservableObject{
    
    @Published var blePeripheralEntity: BlePeripheralDetailEntity
    @Published var isShowIndicator = false
    @Published var isConnectedStatus: CBPeripheralState = .disconnected
    
    var dismissObserver = PassthroughSubject<CBPeripheral?, Never>()
    var peripheral: CBPeripheral?
    
    init(model: BlePeripheralDetailEntity) {
        self.blePeripheralEntity = model
    }
}
