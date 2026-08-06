//
//  Router.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import SwiftUI
import Combine
import Foundation

// DESTINATIONS

enum Route: Hashable {
    case tableList
}

enum SheetRoute: Identifiable, Hashable {
    case placeholder
    var id: String {
        switch self {
        case .placeholder: "placeholder"
        }
    }
}

enum FullScreenRoute: Identifiable, Hashable {
    case placeholder
    var id: String {
        switch self {
        case .placeholder: "placeholder"
        }
    }
}

// ROUTER

final class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var presentedSheet: SheetRoute?
    @Published var presentedFullScreen: FullScreenRoute?
    
    // Push Navigation
    
    func push (_ route: Route) {
        path.append(route)
    }
    
    func pop () {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot () {
        path.removeLast(path.count)
    }
    
    func pop (_ count: Int) {
        path.removeLast(min(count, path.count))
    }
    
    // Modal Navigation
    
    func presentFullScreen (_ route: FullScreenRoute) {
        presentedFullScreen = route
    }
    
    func dismissFullScreen () {
        presentedFullScreen = nil
    }
    
    func presentSheet (_ route: SheetRoute) {
        presentedSheet = route
    }
    
    func dismissSheet () {
        presentedSheet = nil
    }
    
}
