import Foundation

protocol APIHandlerType: AnyObject {
    func login(details: Login, completionHandler: @escaping (Result<Data, Error>) -> Void)
    func getCategories(completionHandler: @escaping (Result<Data, Error>) -> Void)
    func getProducts(category: String, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

final class APIHandler: APIHandlerType {
    
    private enum Constant {
        private static let baseUrl = "https://fakestoreapi.com"
        
        enum URLString {
            static let login = "\(baseUrl)/auth/login"
            static let categories = "\(baseUrl)/products/categories"
            static let getProducts = "\(baseUrl)/products/category/"
        }
    }
    enum HTTP: String {
        case GET
        case POST
    }

    func login(details: Login, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let urlString = Constant.URLString.login
        var urlRequest = createURLRequest(urlString: urlString, httpMethod: .POST)
        urlRequest?.httpBody = jsonData(from: details)
        getData(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    func getCategories(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let urlString = Constant.URLString.categories
        let urlRequest = createURLRequest(urlString: urlString, httpMethod: .GET)
        getData(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    func getProducts(category: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let string = "\(Constant.URLString.getProducts)\(category)"
        let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlRequest = createURLRequest(urlString: urlString, httpMethod: .GET)
        getData(urlRequest: urlRequest, completionHandler: completionHandler)
    }
}

extension APIHandler {

    private func createURLRequest(urlString: String, httpMethod: HTTP) -> URLRequest? {
        guard let components = URLComponents(string: urlString), let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }

    private func getData(urlRequest: URLRequest?, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let request = urlRequest else {
            let error = NSError(domain: "URLError", code: 99, userInfo: nil) as Error
            completionHandler(.failure(error))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let error = error else {
                    let dataToSend = data ?? Data()
                    completionHandler(.success(dataToSend))
                    return
                }
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
}
