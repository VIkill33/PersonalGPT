//
//  snapshot.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/11.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

#if os(macOS)
extension View {
    func snapshot(origin: CGPoint, targetSize: CGSize) -> NSImage? {
        let controller = NSHostingController(rootView: self)
        //let targetSize = controller.view.intrinsicContentSize
        let contentRect = NSRect(origin: origin, size: targetSize)
        
        
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = controller.view
        
        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }
        
        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}
#endif

#if os(iOS)
extension View {
  var snapshot: UIImage {
    let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.top))
    let view = controller.view
    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize)
    view?.backgroundColor = .clear

    let format = UIGraphicsImageRendererFormat()
    let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}
#endif
