//
//  BleConnectTargetDetailViewPresenter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import Foundation
import CoreBluetooth
import Combine

protocol BleConnectTargetDetailViewPresentation {
    
    /// Viewが表示された際の処理
    func didApearView()
    
    /// Viewが非表示にされた際の処理
    func willDisapearView()
    
    /// 接続ボタンをタップした際の処理
    func tappedConnectButton()
    
    /// 切断ボタンをタップした際の処理
    func tappedDisconnectButton()
}

class BleConnectTargetDetailViewPresenter {
    
    var view: BleConnectTargetDetailView!
    var router: BleConnectTargetDetailViewWireframe!
    var interactor: BleConnectTargetDetailViewUseCase!
    var viewModel: BlePeripheralDetailViewModel
    
    init(viewModel: BlePeripheralDetailViewModel) {
        self.viewModel = viewModel
    }
}

extension BleConnectTargetDetailViewPresenter: BleConnectTargetDetailViewPresentation{
    
    func didApearView() {
        return
    }
    
    func willDisapearView() {
        
        viewModel.dismissObserver.send(viewModel.peripheral)
        interactor.disapperProcess()
    }
    
    func tappedConnectButton() {
        
        guard let peripheral = viewModel.peripheral else { return }
        interactor.connectPeripheral(peripheral: peripheral)
    }
    
    func tappedDisconnectButton() {
        
        guard let peripheral = viewModel.peripheral else { return }
        interactor.disconnectPeripheral(peripheral: peripheral)
    }

}
