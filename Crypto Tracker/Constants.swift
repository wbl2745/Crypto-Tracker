//
//  Constants.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/31/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

/*
 Storing all of the constants used in the app here.
 
 It turns out that you can also put constants in AppDelegate.swift, outside of any class and they will
 also be visible. The advantage to this is that there's more documentation about what the constant is used
 for by qualifying it. So the question is whether all app constants should be here, or in a Constants struct?
 
 One way to do this might be to say that constants that are used in multiple files go here, but constants that
 are only used in a single file are located in that file.
 
 History
 =======
 05/31/18 - Beginning.
 
 */

// TODO: Should all constants be here?

import Foundation

struct Constants {
    
    struct UserDefaultsConstants {
        static let AUTH : String = "secure"     // The name of the UserDefault key for whether the
                                                // the app requires authentication.
    } // struct UserDefaultsConstants
    
} // struct Constants
