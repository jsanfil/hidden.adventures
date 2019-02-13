//
//  Log.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-06-23.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import os.log
import Foundation

public struct Log {
    static let log = OSLog(subsystem: "domain", category: "App")
    
    static public func debug(_ message: Any) {
        os_log("DEBUG - %@", log: log, type: .debug, "\(message)")
    }
    
    static public func info(_ message: Any) {
        os_log("INFO - %@", log: log, type: .info, "\(message)")
    }
    
    static public func error(_ message: Any) {
        os_log("ERROR - %@", log: log, type: .error, "\(message)")
    }
}
