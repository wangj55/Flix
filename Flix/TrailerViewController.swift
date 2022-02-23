//
//  TrailerViewController.swift
//  Flix
//
//  Created by Ji Wang on 2/23/22.
//
import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!

    var movie: [String: Any]!
    var key: String = ""

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // get trailer's key
        let id = movie["id"] as! Int

        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, _, error in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                let results = dataDictionary["results"] as! [[String: Any]]
                self.key = self.getTrailerKey(from: results)

                let trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(self.key)")
                let trailerRequest = URLRequest(url: trailerUrl!)
                self.webView.load(trailerRequest)
            }
        }
        task.resume()
    }

    /// Randomly choose a trailer if there are multiple trailers of given movie, otherwise choose the only trailer.
    /// - Returns: The key of chosen trailer.
    private func getTrailerKey(from trailers: [[String: Any]]) -> String {
        let index = Int.random(in: 0 ..< trailers.count)
        let chosenKey = trailers[index]["key"] as! String
        return chosenKey
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
