//
//  BleManager.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import Foundation
import CoreBluetooth
import Combine

protocol BleManagerDelegate {
    
    
}

class BleManager: NSObject{
    
    static var shared = BleManager()
    
    private var central: CBCentralManager!
    private let bleSessionQueue = DispatchQueue(label: "BleSessionQueue")
    private let scanCBOptions = [
        CBCentralManagerScanOptionAllowDuplicatesKey: false,
        CBCentralManagerOptionShowPowerAlertKey: true,
    ]
    
    private var blePowerObserver = PassthroughSubject<Bool, Never>()
    private var peripheralsObserver = PassthroughSubject<BlePeripheralEntity, Never>()
    private var peripheralConnectProcessObserver = PassthroughSubject<CBPeripheral, Error>()
    private var peripheralDisconnectProcessObserver = PassthroughSubject<CBPeripheral, Error>()
    
    private var isObservingConnectPeripheral = false
    
    override init() {
        super.init()
    }
    
    func setupManager() {
        central = CBCentralManager(delegate: self, queue: bleSessionQueue)
    }
    
    func searchAccesory(){
        central.scanForPeripherals(withServices: nil, options: scanCBOptions)
    }
    
    func stopScanPeripheral(){
        central.stopScan()
    }
    
    func createblePowerObserver() -> PassthroughSubject<Bool, Never>{
        return blePowerObserver
    }
    
    func createDiscoveredPeripheralsObserver() -> PassthroughSubject<BlePeripheralEntity, Never>{
        return peripheralsObserver
    }
    
    func createConnectPeripheralObserver() -> PassthroughSubject<CBPeripheral, Error>{
        
        // ペリフェラル接続の監視フラグを立てる
        isObservingConnectPeripheral = true
        return peripheralConnectProcessObserver
    }
    
    func createDisconnectPeripheralObserver() -> PassthroughSubject<CBPeripheral, Error>{
        return peripheralDisconnectProcessObserver
    }
    
    func connectPheral(peripheral: CBPeripheral){
        
        // 接続時にペリフェラルスキャンを中止する
        stopScanPeripheral()
        
        peripheral.delegate = self
        central.connect(peripheral)
    }
    
    func disconnectPheral(peripheral: CBPeripheral){
        central.cancelPeripheralConnection(peripheral)
    }
    
    /// 端末のBleが使用可能かどうか
    func isBlePowerOn() -> Bool {
        return central.state == .poweredOn
    }
    
}

extension BleManager: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
            
        case .poweredOn:
            
            blePowerObserver.send(true)
            searchAccesory()
            break
        case .poweredOff, .unauthorized, .unsupported:
            
            blePowerObserver.send(false)
            break
        default:
            
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //　信号強度に応じて信号を拒否する
        if RSSI.intValue <= -65 { return }
        
        guard let name = peripheral.name else { return }
        
        // アドバタイズデータの取得
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "No Local Name"
        let isConnectable = (advertisementData[CBAdvertisementDataIsConnectable] as? Bool) ?? false
        let serviceUUIDKey = BlePeripheralAdvertiseConverter.convertServiceIdDicToObject(target: advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [String] ?? [])
        
        // オブザーバーにペリフェラルのスキャン結果を通知
        self.peripheralsObserver.send(BlePeripheralEntity(id: peripheral.identifier.uuidString, name: name, peripheral: peripheral, localName: localName, isConnectable: isConnectable, serviceUUIDKey: serviceUUIDKey, rssi: RSSI.intValue))
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("connect status: \(peripheral.state.name())")
        
        // オブザーバーに接続結果を通知
        peripheralConnectProcessObserver.send(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if let error = error {
            
            if isObservingConnectPeripheral {
                
                peripheralConnectProcessObserver.send(completion: .failure(error))
            } else {
                
                peripheralDisconnectProcessObserver.send(completion: .failure(error))
            }
            
            return
        }
        
        // オブザーバーに切断結果を通知
        if isObservingConnectPeripheral {
            
            peripheralConnectProcessObserver.send(peripheral)
        } else {
            
            peripheralDisconnectProcessObserver.send(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            
            // オブザーバーに接続エラーを通知
            peripheralConnectProcessObserver.send(completion: .failure(error))
        }
    }
}

extension BleManager: CBPeripheralDelegate{
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
        print("peripheralDidUpdate State: \(peripheral.state.name())")
        
        switch peripheral.state{
            
        case .disconnected:
            break
        case .connecting:
            break
        case .connected:
            break
        case .disconnecting:
            break
        @unknown default:
            break
        }
    }
}

extension CBPeripheralState{
    
    func name() -> String {
        switch self{
            
        case .disconnected:
            return "未接続"
        case .connecting:
            return "接続試行中"
        case .connected:
            return "接続済み"
        case .disconnecting:
            return "切断中"
        @unknown default:
            return "不明"
        }
    }
}
