//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Bernard Chew on 22/5/15.
//  Copyright (c) 2015 BCHEW. All rights reserved.
//

import Foundation

// class to contain the details of audio clip 
// recorded in Record Sounds View
// that is to be passed to Play Sounds View
// allows the NSURL path to the recorded file
// and title of the file to be stored (& passed)
class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, filePathUrl : NSURL) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
