//
//  BleMngViewModel.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import Foundation
import CoreBluetooth

enum BleCentralStatus {
    case stop
    case scaning
}

enum AlertType {
    case none
    case bleSetting
}

class BleMngViewModel: ObservableObject{
    @Published var alertType: AlertType = .none
    @Published var isBlePoweredOn = false
    @Published var isConnected = false
    @Published var isDiscoveredPeripherals = false
    @Published var peripheralsModels: [BlePeripheralEntity] = []
    @Published var scanPeripheralStatus: BleCentralStatus = .stop
}
