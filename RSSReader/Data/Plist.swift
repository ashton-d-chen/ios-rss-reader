//
//  Plist.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

class Plist {
    var plistName : String
    var path : String
    
    init (plistName : String ) {
        self.plistName = plistName
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.path = rootPath.appending(self.plistName + ".plist")
        
        /*
         //check and see if the file exists in docs directory
         if !NSFileManager.defaultManager().fileExistsAtPath(self.path){
         
         //get the path to the notes.plist in main bundle
         let plistPathInBundle = NSBundle.mainBundle().pathForResource(self.plistName, ofType: "plist")!
         
         //copy the file over
         do {
         try NSFileManager.defaultManager().copyItemAtPath(plistPathInBundle, toPath: self.path)
         } catch let error as NSError {
         print("Cannot copy file: \(error.localizedDescription)")
         return
         }
         }*/
    }
    
    func setPlistName(plistName : String) {
        self.plistName = plistName
    }
    
    func saveData(key : String, data : NSMutableDictionary) {
        let dictionary : NSMutableDictionary = [key : data]
        dictionary.write(toFile: self.path, atomically : true)
    }
    
    func readData() -> NSDictionary? {
        //read the array back in
        let mydictionary = NSDictionary(contentsOfFile:self.path)
        
        return mydictionary!
    }
    
    func removeData(link : String) {
        
    }
}
