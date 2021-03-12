//
//  NetworkManager.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    func getAppData() {
        AF.request("https://mock.koombea.io/mt/api/users/posts",
                   method: .get)
            .responseDecodable(of: AppData.self) { (response) in
                debugPrint(response)
            }
    }
    
}
