//
//  APIConfig.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/6/17.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import Alamofire

// Configuration
enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
    
    static func valueByKey(by key: String) -> String? {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            return nil
        }
        return (object as? String)
    }
}

/// 这个取决于项目的配置
enum ConfigMode: String {
    case Debug = "1"
    case Test = "2"
    case Release = "3"
}

let CurrentEnvironmentKey = "CurrentEnvironmentKey"

// 基础配置
class APIConfig: NSObject {
    
    static let share: APIConfig = {
        let manager = APIConfig()
        return manager
    }()
    
    private var currentBaseRequestURL: URL!
    private var currentBaseRequestURL_V2: URL!
    private var currentDomainBaseURL: URL!
    private var currentMode: ConfigMode!
    
    override init() {
        super.init()
        // Token
        #if DEBUG
        let value = UserDefaults.standard.value(forKey: CurrentEnvironmentKey)
        if let value = value as? String, let mode =  ConfigMode(rawValue: value) {
            switchMode(mode: mode)
        }else {
            setupCurrentConfig()
        }
        #else
        setupCurrentConfig()
        #endif
        // Note: 这里的环境配置有点不一样，Debug、Test都属于【DEBUG模式】
        // 利用配置文件的mode来决定环境
    }
    
    private func setupCurrentConfig() {
        self.currentBaseRequestURL = try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL"))!
        self.currentBaseRequestURL_V2 = try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL_V2"))!
        self.currentDomainBaseURL = try! URL(string: "https://" + Configuration.value(for: "DOMAIN_BASE_URL"))!
        let modeObject = Configuration.valueByKey(by: "MODE")!
        self.currentMode = ConfigMode(rawValue: modeObject)
    }
    
    func switchMode(mode: ConfigMode) {
        self.currentMode = mode
        switch mode {
        case .Debug:
            self.currentBaseRequestURL = URL(string: "https://api-dsh-dev.jianzhiweike.net")!
            self.currentBaseRequestURL_V2 = URL(string: "https://api-jxz-test.jianzhikeji.com")!
            self.currentDomainBaseURL = URL(string: "https://h5-dsh-dev.jianzhikeji.com")!
            break
        case .Test:
            self.currentBaseRequestURL = URL(string: "https://api-dsh-test.jianzhiweike.net")!
            self.currentBaseRequestURL_V2 = URL(string: "https://api-jxz-test.jianzhikeji.com")!
            self.currentDomainBaseURL = URL(string: "https://h5-dsh-test.jianzhikeji.com")!
            break
        case .Release:
            self.currentBaseRequestURL = URL(string: "https://api-dsh.jianzhiweike.net")!
            self.currentBaseRequestURL_V2 = URL(string: "https://api-jxz.jianzhiweike.net")!
            self.currentDomainBaseURL = URL(string: "https://h5-dsh.jianzhikeji.com")!
            break
        }
        UserDefaults.standard.setValue(mode.rawValue, forKey: CurrentEnvironmentKey)
    }
    
    static var baseRequestURL: URL {
        return share.currentBaseRequestURL
    }
    
    static var baseRequestURL_V2: URL {
        return share.currentBaseRequestURL_V2
    }
    
    static var domainBaseURL: URL {
        return share.currentBaseRequestURL
    }
    
    static var mode: ConfigMode {
        return share.currentMode
    }
    
    /// 获取Mock path
    /// - Parameter route: api route
    /// - Returns: path
    static func routeMockPath(_ route: RouterRequestConvertible) -> String {
        let path = route.path
        let pathList = path.components(separatedBy: "/")
        if let last = pathList.last {
            return "\(last).json"
        }
        return ""
    }
    
    /// 获取Header
    /// - Parameter route: api route
    /// - Returns: Dict
    static func routeHeaders() -> [String : String]? {
        return nil
    }
    
    /// 获取Encoding
    /// - Returns: Encoding
    static func routeEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    /// 获取Request
    /// - Parameter route: api route
    /// - Returns: req
    static func routeRequest(_ route: RouterRequestConvertible) throws -> URLRequest {
        let url = route.baseURL.appendingPathComponent(route.path)
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        request.allHTTPHeaderFields = route.headers
        debugPrint("request ------ start -----")
        return try routeEncoding().encode(request, with: route.parameters)
    }
}
