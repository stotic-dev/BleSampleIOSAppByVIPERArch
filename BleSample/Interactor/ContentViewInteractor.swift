//
//  ContentViewInteeractor.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import Combine
import CoreBluetooth

protocol ContetnViewUseCase {
    
    /// View表示後の初期処理
    func initialViewProcess()
    
    /// VIew非表示後の処理
    func disappearProcess()
    
    /// ペリフェラルのスキャンを開始する処理
    func startScanPeripheral()
}

class ContentViewInteractor: ContetnViewUseCase {
    
    let presenter: ContentViewPresentation
    let viewModel: BleMngViewModel
    
    private let bleManager: BleManager
    private var observeCancelable: Set<AnyCancellable> = []
    private var isAppeared = false
    
    init(presenter: ContentViewPresentation, viewModel: BleMngViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
        
        bleManager = BleManager.shared
    }
    
    func initialViewProcess() {
        
        isAppeared = true
        
        viewModel.scanPeripheralStatus = .scaning
        bleManager.setupManager()
        observeBlePower()
        observeBlePeripherals()
    }
    
    func disappearProcess() {
        
        viewModel.scanPeripheralStatus = .stop
        observeCancelable.forEach({ $0.cancel() })
        bleManager.stopScanPeripheral()
    }
    
    func startScanPeripheral() {
        
        observeBlePower()
        observeBlePeripherals()
        
        if bleManager.isBlePowerOn() {
            
            viewModel.scanPeripheralStatus = .scaning
            bleManager.searchAccesory()
        }
        else {
            
            viewModel.alertType = .bleSetting
        }
    }
}

private extension ContentViewInteractor{
    
    /// Bluetooth使用状態の監視
    func observeBlePower() {
        
        bleManager.createblePowerObserver().sink { isPowerOn in
            
            DispatchQueue.main.async {[weak self] in
                
                guard let self = self else { return }
                self.viewModel.isBlePoweredOn = isPowerOn
                self.viewModel.alertType = isPowerOn ? .none : .bleSetting
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
                
                if !self.viewModel.peripheralsModels.isEmpty {
                    
                    // 見つけたperipheralが存在する場合ListViewへ遷移
                    self.presenter.notifyPeripherals()
                }
            }
        }
        .store(in: &observeCancelable)
    }
}
