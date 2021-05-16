import UIKit

class HTTPCommunication: NSObject {
    var completionHandler: ((DataFromServer?) -> Void)?;
    var taskDowload: URLSessionDownloadTask!;
    let request = RequestFactory();
    var currentRequest = "POST"
    
   // init() {
      //  self.completionHandler = completionHandler
    //}
    
    func postURL(_ url: URL, completionHandler: @escaping ((DataFromServer?) -> Void)) {
        self.completionHandler = completionHandler
        currentRequest = "POST"
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = self.request.createRequest()!
        request.addValue("close", forHTTPHeaderField: "Connection")
        //print("http body: ", self.request.createRequest()!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       let session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
       // let session: URLSession = URLSession.shared
        
        taskDowload = session.downloadTask(with: request)
        let task: URLSessionDataTask = session.dataTask(with: request)
        task.resume()
        print("end of postUrl")
    }
    
    func getURL(_ url: URL, completionHandler: @escaping ((DataFromServer?) -> Void)) {
        self.completionHandler = completionHandler
       // self.completionHandler = completionHandler
        currentRequest = "GET"
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
       // request.httpBody = self.request.createRequest()!
        //print("http body: ", self.request.createRequest()!)
        
      //  request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       let session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
       // let session: URLSession = URLSession.shared
        
        taskDowload = session.downloadTask(with: request)
        let task: URLSessionDataTask = session.dataTask(with: request)
        task.resume()
    }
}

extension HTTPCommunication: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish dowload")
        do {
                let data: Data = try Data(contentsOf: location)
                DispatchQueue.main.async(execute: {
                    self.completionHandler!(self.request.parseResponse(data: data, currentRequest: self.currentRequest))
                })
            } catch {
                print("Can't get data from location.")
            }
    }
}

extension HTTPCommunication: URLSessionDataDelegate {

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        var statusCode = 200;
        if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                statusCode = httpResponse.statusCode
        }
        user.responseStatusCode = statusCode
        if (statusCode == 200) {
            taskDowload.resume()
        } else {
            user.errorMessage = "Server error: " + String(statusCode) + ". Please try again"
            DispatchQueue.main.async(execute: {
                self.completionHandler!(nil)
            })
        }
    }
}

extension HTTPCommunication: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
        print("EERRRROOOOOOOOR   ", error)
        let errorCode = (error as! NSError).code
        print("error code", errorCode)
        if errorCode == -1009 {
            user.errorMessage = "No Internet connection"

        } else {
            user.errorMessage = (error as! NSError).localizedDescription
        }
        DispatchQueue.main.async(execute: {
            self.completionHandler!(nil)
        })
    }
    }
    
}

class RequestFactory {
    func createRequest() -> Data? {
        let imageData = user.photo.pngData()
        let imageBase64 = imageData?.base64EncodedString()
        let request = ["file": imageBase64]
        do {
            let result = try JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)
            //print("json request: ", result)
            return result
        } catch {
            print("Invalid json when create request")
            return nil
        }
    }
    
    func parseResponse(data: Data, currentRequest: String) -> DataFromServer? {
        if currentRequest == "POST" {
            return parsePOSTResponse(data: data)
        } else {
            return parseGETResponse(data: data)
        }
    }
    
    func parsePOSTResponse(data: Data) -> DataFromServer? {
        guard let json = String(data: data, encoding: String.Encoding.utf8) else { print("Invalid json")
            return nil
        }
       // print("JSON from server: ", json)
        do {
            let jsonObjectAny: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonObject = jsonObjectAny as? [String: Any],
                let file = jsonObject["file"] as? String,
                let metadata = jsonObject["metadata"] as? [String: Any],
                let colorType = metadata["color_type"] as? Int,
                let photoQuality = metadata["photo_quality"] as? Int else {
                print("Something wrong with json files")
                return nil
            }
            let dataDecoded:NSData = NSData(base64Encoded: file, options: NSData.Base64DecodingOptions(rawValue: 0))!

            let decodedImage:UIImage = UIImage(data: dataDecoded as Data)!

            let data = DataFromServerPOST(file: decodedImage, colorType: colorType, photoQuality: photoQuality)
            return data
        } catch {
            print("Can't serialize data.")
            return nil
        }
    }
    
    func parseGETResponse(data: Data) -> DataFromServer? {
        guard let json = String(data: data, encoding: String.Encoding.utf8) else { print("Invalid json")
            return nil
        }
       // print("JSON from server: ", json)
        do {
            let jsonObjectAny: Any = try JSONSerialization.jsonObject(with: data, options: [])
            var colors: [String: [[String]]] = [:]
            let jsonObject = jsonObjectAny as! [[String: Any]]
            for season in jsonObject {
                let seasonType = season["type"] as! String
                let possibleColors = season["possible_colors"] as! [[String: Any]]
                colors[seasonType] = []
                for j in possibleColors {
                    let hexValues = j["hex_values"] as! [String]
                    colors[seasonType]?.append(hexValues)
                }
            }

            let data = DataFromServerGET(colors: colors)
            return data
        } catch {
            print("Can't serialize data.")
            return nil
        }
    }
}

class DataFromServer {}

class DataFromServerPOST: DataFromServer {
    let file: UIImage;
    let colorType: Int;
    let photoQuality: Int;
    init(file: UIImage, colorType: Int, photoQuality: Int) {
        self.file = file
        //пока не написала обработчик, если качество фото плохое
        if colorType == -1 {
            self.colorType = 0
        } else {
            self.colorType = colorType
        }
        self.photoQuality = photoQuality
    }
}

class DataFromServerGET: DataFromServer {
    var colors: [String: [[String]]]
    init(colors: [String: [[String]]]) {
        self.colors = colors
    }
}
