//
//  APIManager.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/13/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APIManager{
    static let shared = APIManager()
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    // API to login an user
    func login(userType: String, completionHandler: @escaping(NSError?)-> Void)
    {
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": FBSDKAccessToken.current().tokenString,
            "user_type": userType
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError)
                break
            }
        }
    }
    
    // API to log an user out
    func logout(completionHandler: @escaping(NSError?)-> Void)
    {
        let path = "api/social/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": self.accessToken
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
            
            switch response.result {
            case .success:
                completionHandler(nil)
            break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
        
    }
    
    // API to refresh token when it's expired
    func refreshTokenIfNeed(completionHandler: @escaping()-> Void)
    {
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        if (Date() > self.expired) {
            Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    completionHandler()
                    break
                case .failure:
                    break
                    
                }
            })
        } else {
            completionHandler()
        }
    }
    
    // Request Server function
    func requestServer(_ method: HTTPMethod, _ path: String, _ params:[String: Any]?, _ encoding: ParameterEncoding, _ completionHandler: @escaping(JSON) -> Void) {
        
        let url = baseURL?.appendingPathComponent(path)
        
        //        refreshTokenIfNeed {
        Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                completionHandler(jsonData)
                break
                
            case .failure:
                completionHandler(JSON.null)
                break
            }
            
        }
    }
    
    //API getting restaurant list
    func getRestaurants(completionHandler: @escaping(JSON) -> Void)
    {
        let path = "api/customers/restaurants/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
        
    }
    
    // API get list of meals of a restaurant
    func getMeals(restaurantId: Int, completionHandler: @escaping(JSON) -> Void) {
       
        let path = "api/customers/meals/\(restaurantId)"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)

    }
    
    
    
}
