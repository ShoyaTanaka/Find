//
//  FinderSync.swift
//  FindEx
//
//

import Cocoa
import FinderSync


class FinderSync: FIFinderSync{
    let userDefaults = UserDefaults(suiteName:"com.lightning.Find")
    var myFolderURL = URL(fileURLWithPath: "/")

    var Win = NSWindow()
    var tes:String? = nil
    override init() {
        super.init()
 
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
        // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
/*        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.colorPanelName)!, label: "Status One" , forBadgeIdentifier: "One")
        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.cautionName)!, label: "Status Two", forBadgeIdentifier: "Two")*/
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
/*    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once
        NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
    }
    
    
    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
        NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
    }*/
    
   override func requestBadgeIdentifier(for url: URL) {
        NSLog("requestBadgeIdentifierForURL: %@", url.path as NSString)
        
        // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.

    }
    
    // MARK: - Menu and toolbar item support
    
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        
        let sub = NSMenu()
        let def = userDefaults!.array(forKey: "typeArray") as! [String]
        let menu = NSMenu(title: "create text")
        for x in def {
        sub.addItem(withTitle: x, action: #selector(sampleAction(_:)), keyEquivalent: "")
        
        }
        let subItem = NSMenuItem(title: "create text", action: nil, keyEquivalent: "")
        menu.addItem(subItem)
        switch menuKind {
        case .contextualMenuForItems:menu.setSubmenu(sub, for: subItem)
        case .contextualMenuForContainer:menu.setSubmenu(sub, for: subItem)
        default: print(1==1)
        }
        return menu
    }
    
    @IBAction func sampleAction(_ sender: AnyObject?) {
        var err:Error? = nil
        let target = FIFinderSyncController.default().targetedURL()
        let items = FIFinderSyncController.default().selectedItemURLs()
        var assigndir:[String]
        var tester = false
        var cur:String? = nil
        
        if let assi:[String] = userDefaults!.array(forKey: "currentdirs") as? [String] {
            assigndir = assi
        }
        else {
            userDefaults!.set([],forKey: "currentdirs")
            assigndir = []
        }
        let item = sender as! NSMenuItem
        let selected = item.title
        NSLog("sampleAction: menu item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
        for x in assigndir {
            if (target!.absoluteString.contains(x) && x.count != 0) {
                var tari:String = ""
                let all = userDefaults?.dictionaryRepresentation()
                var current:String = ""
                if (userDefaults!.object(forKey: x) != nil){
                    let contain = userDefaults!.object(forKey: x)
                    let sec = userDefaults!.object(forKey: x) as! Data
                    var ok = false
                    let securl = try! URL.init(resolvingBookmarkData: sec, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &ok)
                    let success = securl.startAccessingSecurityScopedResource()
                NSLog("assigndir:\(x)")
                    let tar = target!.path
                    let blank = ""
                    var counter = 1
                    if securl.path != tar {
                        let before = tar.index(tar.startIndex,offsetBy: securl.path.count+1)
                        let end = tar.index(tar.endIndex,offsetBy: -1)
                        if before < end {
                         tari = String(tar[before...end])
                         current = target!.appendingPathComponent("document\(counter)\(selected)").path
                        }
                        else {
                            current = target!.appendingPathComponent("document\(counter)\(selected)").path
                        }
                    }
                    else {
                        tari = ""
                    }

                    var currentdir = ""
                    while true {
                        var isDir:ObjCBool = false
                        if (FileManager.default.fileExists(atPath:target!.appendingPathComponent("document\(String(counter))\(selected)").path,isDirectory: &isDir ) == false) {
                            currentdir = String(tari)+"document\(String(counter))\(selected)"
                            //String(securl.appendingPathComponent(String(tari)+"document\(counter).txt").absoluteString.suffix(securl.appendingPathComponent(String(tari)+"document\(counter).txt").absoluteString.count - 7))
                            break
                        }
                        else {
                            counter += 1
                        }
                    }
                    do {
                        cur = securl.appendingPathComponent(String(tari)+"/document\(counter)\(selected)").path
                        try blank.write(to: securl.appendingPathComponent(String(tari)+"/document\(counter)\(selected)"), atomically: true, encoding: .utf8)
                    }
                    catch let E {
                        err = E
                    }
                    return
                }

            }
        }

        DispatchQueue.main.async{
            self.Win = NSWindow()
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.directoryURL = target
        panel.beginSheetModal(for:self.Win){result in
                if result == .OK {
                let Dir = panel.urls[0]
                    let bookmark = try! Dir.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    self.userDefaults!.set(bookmark, forKey: target!.absoluteString)
                    assigndir.append(target!.absoluteString)
                    self.userDefaults!.set(assigndir,forKey: "currentdirs")
                    let blank = ""
                    var counter = 1
                    while true {
                        if (!FileManager.default.fileExists(atPath: target!.appendingPathComponent("document\(counter)\(selected)").path)) {
                            break
                        }
                        else {
                            counter += 1
                        }
                    }
                    do {
                        try blank.write(to: target!.appendingPathComponent("document\(counter)\(selected)"), atomically: true, encoding: .utf8)
                    }
                    catch let E {
                        NSAlert(error: E).runModal()
                    }
                    NSLog("Path:\(target!.absoluteString)")
                    
            }
            self.Win.close()
        }
        }
        
        for obj in items! {
            NSLog("    %@", obj.path as NSString)
        }
       
    }


}


