//
//  CiniiSearch.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/02/26.
//

import Alamofire
import SwiftyJSON
import UIKit

protocol SearchDataSource {
    func searchResults(articleArray: [Article], count: Int)
}

class CiniiSearch {
    
    private var searchText: String?
    private var resultArray = [Article]()
    var searchDataSource: SearchDataSource?
    
    init(searchText: String?) {
        self.searchText = searchText
    }
    
    func setupData() {
        guard let searchText = searchText else {
            return
        }
        let searchWords = searchText.replacingOccurrences(of: " ", with: "+")
        let url = "https://ci.nii.ac.jp/opensearch/search?q=\(searchWords)&range=0&count=100&sortorder=7&format=json&type=0&appid=7oPddfvWLO8qAEvaAsWl"
        let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       
        AF.request(encodedUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success:
                do {
                    let json: JSON = try JSON(data: response.data!)
                    let totalResultCountString = json["@graph"][0]["opensearch:totalResults"].string
                    var totalResultCount = Int(totalResultCountString!)!
                    if totalResultCount > 100 {
                        totalResultCount = 100
                    }
                    if totalResultCount != 0 {
                        for i in 0...totalResultCount - 1 {
                            let title = json["@graph"][0]["items"][i]["title"].string
                            let link = json["@graph"][0]["items"][i]["link"]["@id"].string
                            var dcCreators = [String]()
                            json["@graph"][0]["items"][i]["dc:creator"].array?.forEach { json in
                                dcCreators.append(json["@value"].string!)
                            }
                            let dcPublisher = json["@graph"][0]["items"][i]["dc:publisher"].string
                            let prismPublicationName = json["@graph"][0]["items"][i]["prism:publicationName"].string
                            let description = json["@graph"][0]["items"][i]["description"].string
                            let dcDate = json["@graph"][0]["items"][i]["dc:date"].string
                            let article = Article(title: title, link: link, dcCreator: dcCreators, dcPublisher: dcPublisher, prismPublicationName: prismPublicationName, description: description, dcDate: dcDate)
                            self.resultArray.append(article)
                        }
                        self.searchDataSource?.searchResults(articleArray: self.resultArray, count: self.resultArray.count)
                    }
                    
                } catch {
                    print("Error:" + error.localizedDescription)
                }
            case .failure:
                break
            }
        }
    }
}
