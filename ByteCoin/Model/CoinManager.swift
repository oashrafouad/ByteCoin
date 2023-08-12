import Foundation

struct CoinManager {
    
    let baseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY")
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String)
    {
        let urlString = "\(baseUrl)/\(currency)?apikey=\(apiKey!)"
        
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                if error != nil
                {
                    print(error!)
                }
          
                if let safeData = data
                {
                    let decoder = JSONDecoder()
                    do
                    {
                        let decodedData = try decoder.decode(CoinData.self, from: safeData)
                        print(decodedData.rate)
                    }
                    catch
                    {
                        print(error)
                    }
                }
            })
            task.resume()
        }
    }
}
