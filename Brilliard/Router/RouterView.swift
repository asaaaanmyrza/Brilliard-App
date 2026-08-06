//
//  RouterView.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import SwiftUI

struct RouterView<Content: View>: View {
    
    @StateObject var router = Router()
    private let root: () -> Content
    
    init(@ViewBuilder root: @escaping () -> Content) {
        self.root = root
    }
    
    var body: some View {
        NavigationStack (path: $router.path) {
            root()
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .environmentObject(router)
        .sheet(item:$router.presentedSheet) { sheet in
            sheetDestination(for: sheet)
                .environmentObject(router)
        }
        .fullScreenCover(item:$router.presentedFullScreen) { fullScreen in
            fullScreenDestination(for:fullScreen)
                .environmentObject(router)
        }
    }
    
    @ViewBuilder
    func destination(for route: Route) -> some View {
    }
    
    @ViewBuilder
    func sheetDestination(for sheet: SheetRoute) -> some View {
        switch sheet {
        case .placeholder:
            Text("Placeholder")
        }
    }
    
    @ViewBuilder
    func fullScreenDestination(for fullScreen: FullScreenRoute) -> some View {
        switch fullScreen {
        case .placeholder:
            Text("Placeholder")
        }
    }
}
