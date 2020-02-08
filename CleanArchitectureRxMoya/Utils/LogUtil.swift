//
//  LogUtil.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/8.
//  Copyright © 2020 Jeff. All rights reserved.
//

import XCGLogger

struct LogUtil {
    
    static func releaseLogger() -> XCGLogger {
        let log = XCGLogger.default
        log.setup(level: .error, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .error)
        return log
    }
    
    static func advancedLogger() -> XCGLogger {
        // Setup XCGLogger (Advanced/Recommended Usage)
        // Create a logger object with no destinations
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        
        setLogLevelFormat(log)
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.appleSystemLogDestination")

        // Optionally set some configuration options
        systemDestination.outputLevel = .verbose
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true

        // Add the destination to the logger
        log.add(destination: systemDestination)

        // Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
        
        return log
    }
    
    static func setLogLevelFormat(_ log: XCGLogger) {
        log.levelDescriptions[.verbose] = "🗯"
        log.levelDescriptions[.debug] = "🔷"
        log.levelDescriptions[.info] = "📱"
        log.levelDescriptions[.notice] = "💡"
        log.levelDescriptions[.warning] = "⚠️"
        log.levelDescriptions[.error] = "‼️"
        log.levelDescriptions[.severe] = "💣"
        log.levelDescriptions[.alert] = "🔔"
        log.levelDescriptions[.emergency] = "🚨"
    }
}
