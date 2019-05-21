import Foundation
import Alamofire


class ServiceManager: NSObject
{
    var reachability : NetworkReachabilityManager?
    static let instance = ServiceManager()
    var alertShowing = false
    
    
    enum Method: String
    {
        case GET_REQUEST = "GET"
        case POST_REQUEST = "POST"
        case PUT_REQUEST = "PUT"
        case DELETE_REQUEST = "DELETE"
    }
    
    
   func makeGetCallWithAlamofire(endPoint : String ,completionHandler: @escaping ( NSDictionary) -> ()) {
      //  let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(endPoint)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print(response)
                    if let JSON = response.result.value{
                        
                        //debugPrint("Repsonse::\(JSON)");
                        
                        DispatchQueue.main.async {
                            
                            let responseJson = JSON as? NSDictionary
                            completionHandler(responseJson!)
                            // If User is not an authorized user then logout from the app
                            print(responseJson)
                            
                            
                            // completionClosure(responseJson, nil)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    // Common.showAlert(message: error.localizedDescription)
                    //completionClosure(JSON as? NSDictionary, nil)
                }
                
    }
        }

    
    //Alamofire.request(kApiURL, method: method, parameters: parameters, encoding: encoding, headers: headers)
    func request(method: HTTPMethod, URLString: String, parameters: [String : Any]?, encoding: ParameterEncoding, headers:  [String: String]? ,completionHandler: @escaping (_ success:Bool?,[String : AnyObject]?, NSError?) -> ())
    {
        if ReachabilityNetwork.isConnectedToNetwork() == true
        {
            var paramValues:Parameters?
            paramValues = parameters as? Parameters
            
            print("REQUEST URL :: \(BASEURL)")
            print("REQUEST PARAMETERS :: \(String(describing: paramValues))")
            
            //Header Implementation
            
            var headers: HTTPHeaders = [:]
            
            
            
            headers = [
                "Content-Type"  : "application/json"
              
            ]
            
            let url = URL(string: BASEURL)

            
            // Remove above code if you dont want to Header
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 10
            
            manager.request(url!,method:.post,parameters:paramValues,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
                
                switch response.result {
                case .success:
                    print(response)
                    if let JSON = response.result.value{
                        
                        //debugPrint("Repsonse::\(JSON)");
                        
                        DispatchQueue.main.async {
                            
                            let responseJson = JSON as? NSDictionary
                            
                            // If User is not an authorized user then logout from the app
                            print(responseJson)
                        
                            
                           // completionClosure(responseJson, nil)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                   // Common.showAlert(message: error.localizedDescription)
                    //completionClosure(JSON as? NSDictionary, nil)
                }
                
            }
            
        }

        else
        {
            if(!self.alertShowing)
            {
                self.alertShowing = true
                let alert = UIAlertController(title: "Network Problem", message: Message_Constants.kAlertNoNetworkMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (act) in
                    self.alertShowing = false
                }))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            completionHandler(false ,nil, NSError(domain:"somedomain", code:9002))
            
        }
    }
}





extension UIApplication
{
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController
        {
            return topViewController(base: presented)
        }
        return base
    }
}
