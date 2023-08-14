import Foundation

protocol CoinManagerDelegate
{
    func didUpdatePrice(currency: String, price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseUrl = "https://api.exchangerate.host/latest?base=BTC"
    var currencyArray = ["AED","AUD","BHD","BRL","CAD","CNY","DZD","EGP","EUR","GBP","HKD","IDR","INR","IQD","JPY","KWD","LBP","LYD","MAD","MXN","NOK","NZD","PLN","QAR","RON","RUB","SAR","SEK","SGD","SYP","TND","USD","YAR","ZAR"]
    
    func getCoinPrice(for currency: String)
    {
        let urlString = "\(baseUrl)&symbols=\(currency)"
        print(urlString)
        
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
//                    print(String(data: safeData, encoding: .utf8)!)
                    let decoder = JSONDecoder()
                    do
                    {
                        let decodedData = try decoder.decode(CoinData.self, from: safeData)
                        let priceString = String(format: "%.2f", decodedData.rates["\(currency)"]!)
                        delegate?.didUpdatePrice(currency: currency, price: priceString)
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
