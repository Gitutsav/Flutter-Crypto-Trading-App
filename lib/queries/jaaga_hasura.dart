String readhasuraBTCData = """
query get_tickers {
  miniTicker(limit: 1000, where: {symbol: {_like:"%BTC"}}, order_by: {eventTime: desc}) {
    symbol
    eventTime
    close
    low
    volume
  }
}
"""
    .replaceAll('\n', ' ');

String readhasuraBNBData = """
query get_tickers {
  miniTicker(limit: 1000, where: {symbol: {_like:"%BNB"}}, order_by: {eventTime: desc}) {
    symbol
    eventTime
    close
    low
    volume
  }
}
"""
    .replaceAll('\n', ' ');
String readhasuraETHData = """
query {
  miniTicker(limit: 1000,where:{symbol:{_nsimilar:"%(BTC|BNB|USDT)"}}, order_by: {eventTime: desc}) {
    symbol
    eventTime
    close
    low
    volume
  }
}
"""
    .replaceAll('\n', ' ');
String readhasuraUSDTData = """
query get_tickers {
  miniTicker(limit: 1000, where: {symbol: {_like:"%USDT"}}, order_by: {eventTime: desc}) {
    symbol
    eventTime
    close
    low
    volume
  }
}
"""
    .replaceAll('\n', ' ');


String updateDefaultProfit = """
mutation update_profit (\$value: numeric,\$userid: numeric){
  update_users(where: {id: {_eq: \$userid}}, _set: {default_profit  : \$value}) {
    affected_rows
  }
}
"""
    .replaceAll('\n', ' ');

String updateDefaultStopLoss = """
mutation update_profit (\$value: numeric,\$userid: numeric){
  update_users(where: {id: {_eq: \$userid}}, _set: {default_stop_loss  : \$value}) {
    affected_rows
  }
}
"""
    .replaceAll('\n', ' ');

String updateDefaultTrailingBuy = """
mutation update_profit (\$value: numeric,\$userid: numeric){
  update_users(where: {id: {_eq: \$userid}}, _set: {default_trailing_buy  : \$value}) {
    affected_rows
  }
}
"""
    .replaceAll('\n', ' ');

String updateDefaultTrailingSell = """
mutation update_profit (\$value: numeric,\$userid: numeric){
  update_users(where: {id: {_eq: \$userid}}, _set: {default_trailing_sell  : \$value}) {
    affected_rows
  }
}

"""
    .replaceAll('\n', ' ');


String getPercentage = """
query percentage_query(\$userId: Int,\$tradeId: Int) {
  requestedTrades(where: {userId: {_eq: \$userId},id:{_eq:\$tradeId}},order_by:{timestamp:desc}) {
    id
    symbol
    buyQuantity
    buyPrice
    sellQuantity
    sellPrice
    stopLoss
    buyTrailing
    sellTrailing
    timestamp
    completedtradessBylinkedto(where: {linkedTo: {_eq: \$tradeId}}) {
    id
    buyQuantity
    buyPrice
    sellQuantity
    sellPrice
    timestamp
    }
  }
}
"""
    .replaceAll('\n', ' ');


String sellReqTrades="""
query get_sell_trades(\$userId: Int,\$tradeId: Int){
  requestedTrades(where: {userId: {_eq: \$userId},id:{_eq:\$tradeId}}) {
    symbol
    sellQuantity
    sellPrice
    timestamp
  }
}
"""
    .replaceAll('\n', ' ');

String completedTrades="""
query get_completed_trades(\$userId: numeric) {
  requestedTrades(where: {userId: {_eq: \$userId}, is_complete: {_eq: true}}) {
    symbol
    buyQuantity
    buyPrice
    timestamp
  }
}
"""
    .replaceAll('\n', ' ');

String wallet="""
query get_wallet_info(\$userId: numeric) {
  wallet(where: {user_id: {_eq: \$userId}}) {
    coin
    holding
    modified_at
  }
}
"""
    .replaceAll('\n', ' ');





String updateEditTrades = """
mutation update_requestedTrades(\$id: Int, \$buyCoin: numeric, \$buyPrice: numeric, \$sellCoin: numeric, \$sellPrice: numeric, \$trailingSell: numeric, \$trailingBuy: numeric, \$stopLoss: numeric, \$userid: Int) {
  update_requestedTrades(where: {id: {_eq: \$id}, userId: {_eq: \$userid}}, _set: {buyPrice: \$buyPrice, buyQuantity: \$buyCoin, sellPrice: \$sellPrice, sellQuantity: \$sellCoin, sellTrailing: \$trailingSell, buyTrailing: \$trailingBuy, stopLoss: \$stopLoss}) {
    affected_rows
  }
}
"""
    .replaceAll('\n', ' ');
String insertStartTrades = """
mutation insert_requestedTrades(\$symbol: String, \$buyCoin: numeric, \$buyPrice: numeric, \$sellCoin: numeric, \$sellPrice: numeric, \$trailingSell: numeric, \$trailingBuy: numeric, \$stopLoss: numeric, \$userid: numeric) {
  insert_requestedTrades(objects: {symbol: \$symbol, userId: \$userid, buyTrailing: \$trailingBuy, sellTrailing: \$trailingSell, buyQuantity: \$buyCoin, buyPrice: \$buyPrice, sellQuantity: \$sellCoin, sellPrice: \$sellPrice, stopLoss: \$stopLoss}) {
    affected_rows
  }
}
"""
    .replaceAll('\n', ' ');

String walletUSDTData = """
query(\$coin: String) {
  miniTicker(where:{symbol:{_eq:\$coin}}, limit:1, order_by:{eventTime:desc}) {
    close
    eventTime
  }
}
"""
    .replaceAll('\n', ' ');

String getGraphData = """
query(\$coin: String) {
  miniTicker(where:{symbol:{_eq:\$coin}}, limit:1440) {
    close
    eventTime
  }
}
"""
    .replaceAll('\n', ' ');



