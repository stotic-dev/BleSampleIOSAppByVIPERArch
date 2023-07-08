//
//  BleConnectableListViewInteractor.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import Combine
import CoreBluetooth

protocol BleConnectableListViewUseCase {
    
    /// Viewが非表示になった時の処理
    func disapperProcess()
    
    /// ペリフェラルをスキャンする
    func scanPeripheral()
    
    /// detailViewのdismissを監視する処理
    func setObserveDetailViewDismiss(dissmisObserver: PassthroughSubject<CBPeripheral, Never>)
}

class BleConnectableListViewInteractor: BleConnectableListViewUseCase {
    
    let presenter: BleConnectableListViewPresentation
    let viewModel: BleMngViewModel
    
    private let bleManager = BleManager.shared
    private var observeCancelable: Set<AnyCancellable> = []
    private var dismissObserveCancelable: Set<AnyCancellable> = []
    
    init(presenter: BleConnectableListViewPresentation, viewModel: BleMngViewModel) {
        
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func disapperProcess() {
        
        viewModel.isDiscoveredPeripherals = false
        viewModel.scanPeripheralStatus = .stop
        viewModel.peripheralsModels = []
        bleManager.stopScanPeripheral()
        observeCancelable.removeAll()
    }
    
    func scanPeripheral() {
        
        bleManager.searchAccesory()
        observeBlePower()
        observeBlePeripherals()
    }
    
    func setObserveDetailViewDismiss(dissmisObserver: PassthroughSubject<CBPeripheral, Never>) {
        
        dissmisObserver
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral in
            
            guard let self = self else { return }
            updatePeripheralViewModel(updateTarget: peripheral)
        }
        .store(in: &dismissObserveCancelable)
    }
    
}

private extension BleConnectableListViewInteractor{
    
    /// Bluetooth使用状態の監視
    func observeBlePower() {
        
        bleManager.createblePowerObserver().sink { isPowerOn in
            
            DispatchQueue.main.async {[weak self] in
                
                guard let self = self else { return }
                self.viewModel.isBlePoweredOn = isPowerOn
            }
        }.store(in: &observeCancelable)
    }
    
    /// BluetoothのPeripheralスキャンの監視
    func observeBlePeripherals() {
        
        bleManager.createDiscoveredPeripheralsObserver().sink {[weak self] peripheral in
            
            DispatchQueue.main.async {
                
                guard let self = self,
                self.viewModel.peripheralsModels.filter({$0.id == peripheral.id}).count == 0 else { return }
                
                print("Discoverd peripheral name: \(String(describing: peripheral.name)), id value: \(peripheral.id)")
                
                self.viewModel.peripheralsModels.append(peripheral)
            }
        }
        .store(in: &observeCancelable)
    }
    
    /// ViewModelのペリファラルの配列の接続ステータスを更新
    func updatePeripheralViewModel(updateTarget: CBPeripheral) {
        
        viewModel.peripheralsModels = viewModel.peripheralsModels.map({ entity in
            
            if entity.peripheral.identifier != updateTarget.identifier { return entity }
            return BlePeripheralEntity(id: entity.id, name: entity.name, peripheral: updateTarget, localName: entity.localName, isConnectable: entity.isConnectable, serviceUUIDKey: entity.serviceUUIDKey, rssi: entity.rssi)
        })
    }
}
