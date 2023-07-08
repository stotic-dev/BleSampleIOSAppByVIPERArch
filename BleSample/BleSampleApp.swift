//
//  BleSampleApp.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import SwiftUI

@main
struct BleSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViewRouter.assembleModule(viewModel: BleMngViewModel())
        }
    }
}
