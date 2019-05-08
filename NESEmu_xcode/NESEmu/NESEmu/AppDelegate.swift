//
//  AppDelegate.swift
//  NESEmu
//
//  Created by Ethan Williams on 5/7/19.
//  Copyright © 2019 NESEmu. All rights reserved.
//


import Cocoa
import NESKit

struct NESSystem {
    var gamepack: NESKitGamepak
    var joypad0: NESKitInputDevice
    var joypad1: NESKitInputDevice
    var ppu: NESKitPPU
    var cpuMemory: NESKitMemory
    var cpu: NESKitCPU
    
    static var ROMPath: String = ""
    static let shared = NESSystem(filename: ROMPath)
    
    init(filename: String) {
        self.gamepack = NESKitGamepak.init(file: filename)
        self.gamepack.powerup()
        self.joypad0 = NESKitInputDevice.init(num: -1)
        self.joypad1 = NESKitInputDevice.init(num: -2)
        self.ppu = NESKitPPU.init(gamepak: self.gamepack)
        self.cpuMemory = NESKitMemory.init(ppu: self.ppu, gamepak: self.gamepack, inputDevice1: self.joypad0, inputDevice2: self.joypad1)
        self.cpu = NESKitCPU.init(memory: self.cpuMemory)
        self.ppu.assign_cpu(self.cpu)
        self.cpu.powerup()
        self.ppu.powerup()
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var mainWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose a rom file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["nes"];
        
        dialog.begin { (result) in
            guard result == NSApplication.ModalResponse.OK, dialog.urls.isEmpty == false, let url = dialog.urls.first else {
                print("Error")
                NSApplication.shared.terminate(self)
                return
            }
            print(url)
            print(url.path)
            NESSystem.ROMPath = url.path
            
            _ = NESSystem.shared
            
            self.mainWindow.makeKeyAndOrderFront(self)
            
        }
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}
