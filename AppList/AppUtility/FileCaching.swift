//
//  FileCaching.swift
//  AppList
//
//  Created by iOS on 18/01/23.
//

import Foundation


public class FileCaching{
    
    static public let shared = FileCaching()
    
    //cachesDirectory
    private let directoryType = FileManager.SearchPathDirectory.cachesDirectory
    
    @objc/// Downloads a file asynchronously
    public func loadFileAsync(url: URL,fileDirectoryPath:String,filename:String,replaceOldFile:Bool = false,removeDirectoryData:Bool = true, completion: @escaping (Bool,_ localFilePath: URL?) -> Void) {
        
        // create your document folder url
        let documentsUrl = FileManager.default.urls(for: directoryType, in: .userDomainMask)[0]

        // your destination file url
        let destination = documentsUrl.appendingPathComponent(fileDirectoryPath).appendingPathComponent(filename)
        if FileManager().fileExists(atPath: destination.path) {
            
            if replaceOldFile == false {
                completion(true, destination)
                return
            }
            
            print("The file already exists at path, deleting and replacing with latest")
            if FileManager().isDeletableFile(atPath: destination.path){
                do{
                    try FileManager().removeItem(at: destination)
                    print("previous file deleted")
                    self.saveFile(url: url, destination: destination) { (complete) in
                        if complete{
                            completion(true, destination)
                        }else{
                            completion(false, nil)
                        }
                    }
                }catch{
                    print("current file could not be deleted")
                }
            }
            
        }else{
            
            //Remove old data in folder if available
            if removeDirectoryData{
                self.removeDirectory(path: fileDirectoryPath)
            }
            
            //Create new directory if not present
            self.createDirectory(path: fileDirectoryPath)
            
            // download the data from your url
            self.saveFile(url: url, destination: destination) { (complete) in
                if complete{
                    completion(true, destination)
                }else{
                    completion(false, nil)
                }
            }
        }
    }
    
    @objc
    private func saveFile(url: URL, destination: URL, completion: @escaping (Bool) -> Void){
        
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            // after downloading your data you need to save it to your destination url
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let location = location, error == nil
            else { print("error with the url response"); completion(false); return}
            do {
                try FileManager.default.moveItem(at: location, to: destination)
                completion(true)
            } catch {
                print("file could not be saved: \(error)")
                completion(false)
            }
        }).resume()
    }
    
    //MARK:- Create directory path
    func createDirectory(path:String){
        
        let documentDirectoryURL = FileManager.default.urls(for: directoryType, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent(path, isDirectory: true)
        
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            print(directoryURL.path)
        } else {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                print(directoryURL.path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK:- Remove directory
    func removeDirectory(path:String){
        
        let documentDirectoryURL = FileManager.default.urls(for: directoryType, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent(path, isDirectory: true)
        
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            
            do {
                try FileManager.default.removeItem(atPath: directoryURL.path)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            //Directory not present
        }
    }
}
