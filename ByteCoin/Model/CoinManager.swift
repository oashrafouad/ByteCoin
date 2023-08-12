import Foundation

protocol CoinManagerDelegate
{
    func didUpdatePrice(currency: String, price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
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
                    delegate?.didFailWithError(error: error!)
                }
          
                if let safeData = data
                {
                    let decoder = JSONDecoder()
                    do
                    {
                        let decodedData = try decoder.decode(CoinData.self, from: safeData)
                        let currency = decodedData.asset_id_quote
                        let price = String(format: "%.2f", decodedData.rate)
                        delegate?.didUpdatePrice(currency: currency, price: price)
                    }
                    catch
                    {
                        delegate?.didFailWithError(error: error)
                    }
                }
            })
            task.resume()
        }
    }
}
