//
//  NewsView.swift
//  SpaceNews
//
//  Created by Youssif Hany on 23/10/2022.
//

import SwiftUI

struct NewsView: View {
    
    @EnvironmentObject var data : SpaceNetworkManager
    @Environment(\.openURL) var openURL
//    private var textWidth = 300.0
    
    var body: some View {
        List{
            ForEach(data.news){ news in
                NewsArticle(title: news.title, imageUrl: news.imageUrl, siteName: news.newsSite, summary: news.summary)
                    .onTapGesture {
                        openURL(URL(string: news.url)!)
                    }
            }
        }
        .task {
                do{
                    data.news = try await data.fetchData()
                }catch APIError.invalidURL {
                    print("Invalid URL")
                }catch APIError.invalidData {
                    print("Invalid Data")
                }catch APIError.invalidResponse {
                    print("Invalid Response")
                }catch {
                    print("Unexpected Error")
                }
            }
//        .refreshable {
//            data.getData()
//        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
            .environmentObject(SpaceNetworkManager())
    }
}
