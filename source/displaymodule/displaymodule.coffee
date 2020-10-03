displaymodule = {name: "displaymodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["displaymodule"]?  then console.log "[displaymodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
displaymodule.initialize = () ->
    log "displaymodule.initialize"
    return

############################################################
displaymodule.sellHead = (sellHead) ->
    log "displaymodule.sellHead"
    displayText = sellHead.volume
    displayText += "€"
    displayText += " | @"
    displayText += sellHead.price
    sellHeadDisplay.textContent = displayText
    return

displaymodule.buyHead = (buyHead) ->
    log "displaymodule.buyHead"
    displayText = buyHead.volume
    displayText += "€"
    displayText += " - @"
    displayText += buyHead.price
    buyHeadDisplay.textContent = displayText
    return

displaymodule.primaryAssetDif = (dif) ->
    log "displaymodule.primaryAssetDif"
    primaryAssetDifDisplay.textContent = dif + "€"
    return

displaymodule.secondaryAssetDif = (dif) ->
    log "displaymodule.secondaryAssetDif"
    secondaryAssetDifDisplay.textContent = dif + "$"
    return

displaymodule.latestPrice = (price) ->
    log "displaymodule.secondaryAssetDif"
    latestPriceDisplay.textContent = price + "$/€"
    return

module.exports = displaymodule