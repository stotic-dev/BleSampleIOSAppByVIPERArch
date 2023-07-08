//
//  BleConnectTargetDetailView.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import SwiftUI
import CoreBluetooth

struct BleConnectTargetDetailView: View {
    
    @ObservedObject var viewModel: BlePeripheralDetailViewModel
    let presenter: BleConnectTargetDetailViewPresenter
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                
                ScrollView {
                    
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            
                            createIdSecionView()
                                .font(.system(size: 30, weight: .bold))
                            
                            Divider()
                            
                            createAdvertiseSection()
                            
                            Divider()
                            
                            createRssiSectionView()
                                .font(.system(size: 30, weight: .regular))
                            
                            Divider()
                            
                            createConnectStatusSectionView(parentSize: proxy)
                            
                            Spacer()
                        }
                        .frame(width: proxy.size.width - 50)
                        
                        Spacer()
                    }
                }
                
                if viewModel.isShowIndicator {
                    
                    Color(.black)
                        .opacity(0.4)
                        .ignoresSafeArea()
                    
                    UtilityViews(viewType: .indicater)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle(viewModel.blePeripheralEntity.name)
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear{
            
            presenter.didApearView()
        }
        .onDisappear{
            
            presenter.willDisapearView()
        }
        
    }
    
    private func createIdSecionView() -> some View {
        HStack{
            Text("id:")
                .padding(.trailing, 30)
            
            Text(viewModel.blePeripheralEntity.id)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func createAdvertiseSection() -> some View {
        Text("AdvertisementData")
            .font(.largeTitle)
            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
        ZStack {
            
            Color(.gray)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 10) {
                
                createKeyValueDispView(key: .localName, value: viewModel.blePeripheralEntity.localName)
                
                createKeyValueDispView(key: .connectable, value: viewModel.blePeripheralEntity.isConnectable)
                
                ForEach(viewModel.blePeripheralEntity.serviceUUIDKey) { serviceUUID in
                    
                    createKeyValueDispView(key: .serviceUUIDKey, value: serviceUUID.key)
                }
            }
            .padding()
        }
    }
    
    private func createRssiSectionView() -> some View {
        
        HStack {
            
            Text("RSSI値")
                .padding(.trailing, 20)
            
            Text(String(viewModel.blePeripheralEntity.rssi))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func createKeyValueDispView(key: BleAdvertisementType, value: Any) -> some View {
        
        HStack {
            
            Text("\(key.getName()): \(selectAdvertisementValue(value: value, type: key))")
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func createConnectStatusSectionView(parentSize: GeometryProxy) -> some View {
        
        VStack(alignment: .leading) {
            Text("Connection Status")
                .font(.largeTitle)
            
            HStack {
                Spacer()
                
                Image(systemName: viewModel.isConnectedStatus == .connected ? "line.3.horizontal.decrease.circle" : "circle.slash")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: parentSize.size.width / 1.5, height: parentSize.size.width / 1.5)
                    .foregroundColor(viewModel.isConnectedStatus == .connected ? .green : .red )
                
                Spacer()
            }
            
            HStack {
                Text("Status")
                    .padding(.trailing, 20)
                
                Text(viewModel.isConnectedStatus.name())
                
                Spacer()
            }
            .font(.system(size: 30, weight: .regular))
            
            HStack {
                Spacer()
                
                Button {
                    
                    if viewModel.isConnectedStatus == .connected {
                        
                        presenter.tappedDisconnectButton()
                    }else{
                        
                        presenter.tappedConnectButton()
                    }
                } label: {
                    Text(viewModel.isConnectedStatus == .connected ? "切断" : "接続")
                        .frame(width: parentSize.size.width / 3, height: 50)
                        .background(.teal)
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(20)
                        .contentShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Spacer()
            }
        }
    }
    
    private func selectAdvertisementValue(value: Any, type: BleAdvertisementType) -> String{
        
        var resutlString: String
        
        switch type {
            
        case .localName, .serviceUUIDKey:
            
            resutlString = value as? String ?? "No Value"
        case .connectable:
            
            resutlString = (value as? Bool ?? false).description
        }
        
        return resutlString
    }
    
}

struct BleConnectTargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        BleConnectTargetDetailViewRouter.assembleModule(viewModel: BlePeripheralDetailViewModel(model: BlePeripheralDetailEntity(id: "test", name: "testName", isConnectable: true, localName: "testLocalName", serviceUUIDKey: [ServiceUUIDKeys(id: UUID(), key: UUID().uuidString)], rssi: -30)))
    }
}
