robustarbitragemodule = {name: "robustarbitragemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["robustarbitragemodule"]?  then console.log "[robustarbitragemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

display = null

############################################################
primaryAssetDif = 0
secondaryAssetDif = 0
sellHead = {}
buyHead = {}
sellLevel = 0
latestPrice = 0

############################################################
initialPrice = 1
minBag = 10
minDistancePercent = 0.5
minProfitDistance = 2
tradingFeePercent = 0.1 
magnifier = 2

############################################################
robustarbitragemodule.initialize = () ->
    log "robustarbitragemodule.initialize"
    display = allModules.displaymodule
    latestPrice = initialPrice
    robustarbitragemodule.reset()
    return
    
############################################################
displayState = ->
    display.primaryAssetDif(primaryAssetDif)
    display.secondaryAssetDif(secondaryAssetDif)
    display.buyHead(buyHead)
    display.sellHead(sellHead)
    display.latestPrice(latestPrice)
    return

############################################################
#region factorPercentHelpers
sellPercent = (distance) -> 100 + distance
buyPercent = (distance) -> 100 - distance
factor = (percent) -> percent / 100

sellFactor = (distance) -> factor(sellPercent(distance))
buyFactor = (distance) -> factor(buyPercent(distance))

minusFeeFactor = -> buyFactor(tradingFeePercent)
plusFeeFactor = -> sellFactor(tradingFeePercent)
#endregion
    
getSellDistanceFactor = ->
    turnFactor = Math.pow(magnifier, sellLevel)
    distance = minDistancePercent * turnFactor
    return sellFactor(distance)
    
getSellVolume = ->
    turnFactor = Math.pow(magnifier, sellLevel)
    return minBag * turnFactor

############################################################
createFirstSellHead = ->
    log "createFirstSellHead"
    sellLevel = 0
    distanceFactor = getSellDistanceFactor()
    price = latestPrice * distanceFactor
    volume = getSellVolume()
    return {price, volume}

createNextSellHead = ->
    log "createNextSellHead"
    sellLevel++
    distanceFactor = getSellDistanceFactor()
    price = sellHead.price * distanceFactor
    volume = getSellVolume()
    return {price, volume}

createBuyBack = ->
    log "createBuyBack"
    distanceFactor = buyFactor(minProfitDistance)
    newPrice = sellHead.price * distanceFactor
    volume = -primaryAssetDif
    newVolume = sellHead.volume
    newVolumeProportion = newVolume / volume
    oldVolumeProportion = (volume - newVolume) / volume
    price = newPrice
    if sellLevel > 0
        oldPrice = buyHead.price
        price = newVolumeProportion * newPrice + oldVolumeProportion * oldPrice
    return {price, volume}

############################################################
receivedVolumeOnSell = (volume, price) ->
    log "receivedVolumeOnSell"
    return volume * price * minusFeeFactor()

spentVolumeOnBuy = (volume, price) ->
    log "spentVolumeOnBuy"
    return volume * price * plusFeeFactor()

############################################################
robustarbitragemodule.reset = ->
    log "robustarbitragemodule.reset"
    buyHead = {}
    sellHead = createFirstSellHead()
    primaryAssetDif = 0
    secondaryAssetDif = 0
    latestPrice = initialPrice
    displayState()
    return

robustarbitragemodule.eatNextSell = ->
    log "robustarbitragemodule.eatNextSell"
    primaryAssetDif -= sellHead.volume
    secondaryAssetVolume = receivedVolumeOnSell(sellHead.volume, sellHead.price) 
    secondaryAssetDif += secondaryAssetVolume
    latestPrice = sellHead.price
    buyHead = createBuyBack()
    sellHead = createNextSellHead()
    displayState()
    return

robustarbitragemodule.eatNextBuy = ->
    log "robustarbitragemodule.eatNextBuy"
    primaryAssetDif += buyHead.volume
    secondaryAssetVolume = spentVolumeOnBuy(buyHead.volume, buyHead.price)
    secondaryAssetDif -= secondaryAssetVolume
    latestPrice = buyHead.price
    sellHead = createFirstSellHead()
    buyHead = {}
    displayState()
    return


module.exports = robustarbitragemodule