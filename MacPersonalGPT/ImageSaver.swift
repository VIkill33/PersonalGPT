//
//  ImageSaver.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/12.
//

import SwiftUI

func showSavePanel() -> URL? {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.png]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = "Save your image"
    savePanel.message = "Choose a folder and a name to store the image."
    savePanel.nameFieldLabel = "Image file name:"
    
    let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil
}

func savePNG(image: NSImage, path: URL) {
    //let image = NSImage(named: imageName)!
    let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
    let pngData = imageRepresentation?.representation(using: .png, properties: [:])
    do {
        try pngData!.write(to: path)
    } catch {
        print(error)
    }
}
