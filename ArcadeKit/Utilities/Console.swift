//
//  Console.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 3/19/23.
//

import os

struct Console {
    var logger : Logger
    
    init(category: String) {
        logger = Logger(subsystem: "me.chenyuhao.arcadekit", category: category)
    }
    
    func notice(_ message: String) {
        // My sad realization that logger can't be wrapped due to privacy concenrns:
        // https://stackoverflow.com/questions/62675874/xcode-12-and-oslog-os-log-wrapping-oslogmessage-causes-compile-error-argumen
        //logger.notice(message)
    }

}
