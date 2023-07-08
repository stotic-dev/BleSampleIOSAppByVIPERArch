//
//  BleConnectTargetDetailViewInteractor.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import Combine
import CoreBluetooth

protocol BleConnectTargetDetailViewUseCase {
    
    /// VIew非表示時の処理
    func disapperProcess()
    
    /// peripheralとの接続処理
    func connectPeripheral(peripheral: CBPeripheral)
    
    /// peripheralとの切断処理
    func disconnectPeripheral(peripheral: CBPeripheral)
}

class BleConnectTargetDetailViewInteractor: BleConnectTargetDetailViewUseCase {
    
    let presenter: BleConnectTargetDetailViewPresenter
    let viewModel: BlePeripheralDetailViewModel
    
    private let bleManager = BleManager.shared
    private var connectStateObserveCancelable: Set<AnyCancellable> = []
    private var disconnectStateObserveCancelable: Set<AnyCancellable> = []
    
    init(presenter: BleConnectTargetDetailViewPresenter, viewModel: BlePeripheralDetailViewModel) {
        
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func disapperProcess() {
        
        connectStateObserveCancelable.forEach({ $0.cancel() })
        disconnectStateObserveCancelable.forEach({ $0.cancel() })
    }
    
    func connectPeripheral(peripheral: CBPeripheral) {
        
        connectStateObserveCancelable.forEach({ $0.cancel() })
        connectStateObserveCancelable.removeAll()
        
        // インジケータを表示
        viewModel.isShowIndicator = true
        
        bleManager.createConnectPeripheralObserver()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
                switch completion {
                    
                case .finished:
                    
                    print("finished connect peripheral observe")
                case .failure(let error):
                    
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] peripheral in
                
                guard let self = self else { return }
                
                // 接続を試行したペリフェラルの情報を更新する
                self.viewModel.isConnectedStatus = peripheral.state
                self.viewModel.isShowIndicator = false
            }
            .store(in: &connectStateObserveCancelable)

        bleManager.connectPheral(peripheral: peripheral)
    }
    
    func disconnectPeripheral(peripheral: CBPeripheral) {
        
        disconnectStateObserveCancelable.removeAll()
        
        bleManager.createDisconnectPeripheralObserver()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            
            switch completion {
                
            case .finished:
                
                print("finished connect peripheral observe")
            case .failure(let error):
                
                print("error: \(error.localizedDescription)")
            }
        } receiveValue: {[weak self] peripheral in
            
            guard let self = self else { return }
            
            // 接続を試行したペリフェラルの情報を更新する
            self.viewModel.isConnectedStatus = peripheral.state
            self.viewModel.isShowIndicator = false
        }
        .store(in: &disconnectStateObserveCancelable)

        bleManager.disconnectPheral(peripheral: peripheral)
    }
}
