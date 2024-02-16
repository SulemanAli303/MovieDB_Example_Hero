//
//  ApiService.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 15/02/2024.
//

import Foundation
class ApiService {
    static let shared = ApiService()
    
    private func getHeaders()->[String:String] {
            //this can be optimised for future with token
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YTRiMjlkNjlhNWJmOGMwNjkxOTQyYTNmZTcyN2RmZCIsInN1YiI6IjYxNjg2ZjU3OWQ1OTJjMDAyYjYwODcxOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6OF399YBH1im3MWdrvFtpvhu0wrm5pLSKXt_rdDafAk"
        ]
        return headers
    }
    private func getDefaultQueryParams()-> [URLQueryItem] {
        var queryItem:[URLQueryItem] = []
        queryItem.append(URLQueryItem(name:"language",value:"en-US"))
        return queryItem
    }

    
    func getRequest<T:Codable>(endPoint:String,queryParams:[String:String] = [:],completionHandler:@escaping (Result<BaseResponse<T>,Error>)->Void) {
            //defaultURL
        var url:URL!
        var queryParam = queryParams.map{URLQueryItem(name: $0.key, value: $0.value)}
        queryParam.append(contentsOf: getDefaultQueryParams())
        if #available(iOS 16.0, *) {
            url = URL(string: "\(BaseURL)\(endPoint)")!
            url.append(queryItems: queryParam )
        } else {
            url = URL(string: "\(BaseURL)\(endPoint)\(queryParam.map({"\($0.name)=\($0.value ?? "")"}).joined(separator: "&"))")!
        }

        let request = NSMutableURLRequest(url: url ,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 15.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = getHeaders()

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                if (200...204).contains(httpResponse.statusCode),let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedResponse =  try decoder.decode(BaseResponse<T>.self, from: data)
                        completionHandler(.success(decodedResponse))
                    } catch let error {
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                } else {
                    completionHandler(.failure(NSError(domain: "\(BaseURL)", code: httpResponse.statusCode,userInfo: [NSLocalizedDescriptionKey:"Error on server"])))
                }
            } else {
                completionHandler(.failure(NSError(domain: "\(BaseURL)", code: 10001,userInfo: [NSLocalizedDescriptionKey:"Response error"])))
            }
        })

        dataTask.resume()
    }

    func postRequest<T:Codable>(endPoint:String,queryParams:[String:String] = [:],bodyParams:Encodable,completionHandler:@escaping (Result<BaseResponse<T>,Error>)->Void) {
            //defaultURL
        var url:URL!
        var queryParam = queryParams.map{URLQueryItem(name: $0.key, value: $0.value)}
        queryParam.append(contentsOf: getDefaultQueryParams())
        if #available(iOS 16.0, *) {
            url = URL(string: "\(BaseURL)\(endPoint)")!
            url.append(queryItems: queryParam )
        } else {
            url = URL(string: "\(BaseURL)\(endPoint)\(queryParam.map({"\($0.name)=\($0.value ?? "")"}).joined(separator: "&"))")!
        }

        let request = NSMutableURLRequest(url: url ,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 15.0)
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(bodyParams)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = getHeaders()

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                if (200...204).contains(httpResponse.statusCode),let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedResponse =  try decoder.decode(BaseResponse<T>.self, from: data)
                        completionHandler(.success(decodedResponse))
                    } catch let error {
                        completionHandler(.failure(error))
                    }
                } else {
                    completionHandler(.failure(NSError(domain: "\(BaseURL)", code: httpResponse.statusCode,userInfo: [NSLocalizedDescriptionKey:"Error on server"])))
                }
            } else {
                completionHandler(.failure(NSError(domain: "\(BaseURL)", code: 10001,userInfo: [NSLocalizedDescriptionKey:"Response error"])))
            }
        })

        dataTask.resume()
    }
}
