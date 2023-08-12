//
//  CoinData.swift
//  ByteCoin
//
//  Created by Omar Ashraf on 12/08/2023.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

struct CoinData: Codable
{
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
