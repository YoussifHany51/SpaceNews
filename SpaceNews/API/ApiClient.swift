//
//  ApiClient.swift
//  SpaceNews
//
//  Created by Youssif Hany on 23/10/2022.
//  API : https://api.spaceflightnewsapi.net/v3/articles

import Foundation


struct SpaceNews:Codable,Identifiable{
    var id:Int
    var title:String
    var url:String
    var imageUrl:String
    var newsSite:String
    var summary:String
    var publishedAt:String
}

@MainActor class SpaceNetworkManager:ObservableObject{
    @Published var news: [SpaceNews] = []
    
    func getData(){
        guard let url = URL(string: "https://api.spaceflightnewsapi.net/v3/articles")else{
            print("API NOT Found")
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            // This part is used to not force unwrappe data in JSONDecoder 
            guard let data = data else{
                let tempError = error!.localizedDescription
                DispatchQueue.main.async {
                    self.news = [SpaceNews(id: 0, title: tempError, url: "Error", imageUrl: "Error", newsSite: "Error", summary: "Error", publishedAt: "Error")]
                }
                return
            }
            //
            let spaceData = try! JSONDecoder().decode([SpaceNews].self, from: data)
            DispatchQueue.main.async {
                print("Loaded Data \(spaceData.count)")
                self.news = spaceData
            }
        }.resume()
    }
    
    func fetchData() async throws -> [SpaceNews]{
        let endpoint =  "https://api.spaceflightnewsapi.net/v3/articles"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let returnedData = try decoder.decode([SpaceNews].self, from: data)
            return returnedData
        }catch{
            throw APIError.invalidData
        }
    }
}


enum APIError : Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
