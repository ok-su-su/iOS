//
//  Bundle+Extension.swift
//  SSDataBase
//
//  Created by 김건우 on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public extension Bundle {
    
    var baseUrl: URL {
        let url = Bundle.main.infoDictionary?["BASE_URL"] as! String
        return URL(string: url)!
    }
    
    var baseDevUrl: URL {
        let url = Bundle.main.infoDictionary?["BASE_DEV_URL"] as! String
        return URL(string: url)!
    }
    
}
