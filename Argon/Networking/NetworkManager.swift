//
//  NetworkManager.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    let host = "http://localhost:4000"
    
    func getAppData(completion: @escaping (_ appData: AppData?) -> ()) {
        AF.request(host + "/mt/api/users/posts",
                   method: .get)
            .responseDecodable(of: AppData.self) { (response) in
                let result = response.result
                switch result {
                case .success:
                    do {
                        let appData = try result.get()
                        completion(appData)
                    } catch {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
    }
    
}
