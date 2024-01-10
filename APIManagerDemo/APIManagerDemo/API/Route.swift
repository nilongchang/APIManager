//
//  Route.swift
//  APIManager_Example
//
//  Created by Jie on 2022/3/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import APIManager
import Alamofire

// protocol
protocol RouterRequestConvertible: URLRequestConvertible {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: [String: String]? { get }
    var stubMockPath: String { get }
}

// Router
enum Router: RouterRequestConvertible {
    
    // API list
    var baseURL: URL {
        return APIConfig.baseRequestURL
    }
    
    /// 默认为get / 如果是其他的，需要指定
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    // MARK: - 以下配置走默认 ----------------------------
    // 命名规范好，默认取path/的最后一个
    // 如/jxz/works/list 则定义为 list.json
    var stubMockPath: String {
        return APIConfig.routeMockPath(self)
    }
    
    var headers: [String : String]? {
        return APIConfig.routeHeaders()
    }
    
    func asURLRequest() throws -> URLRequest {
        return try APIConfig.routeRequest(self)
    }
}
