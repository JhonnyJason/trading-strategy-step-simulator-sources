controlmodule = {name: "controlmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["controlmodule"]?  then console.log "[controlmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion


############################################################
strategy = null

############################################################
controlmodule.initialize = () ->
    log "controlmodule.initialize"
    strategy = allModules.robustarbitragemodule

    resetButton.addEventListener("click", resetButtonClicked)
    eatNextSellButton.addEventListener("click", eatNextSellButtonClicked)
    eatNextBuyButton.addEventListener("click", eatNextBuyButtonClicked)
    return

############################################################
resetButtonClicked = ->
    log "resetButtonClicked"
    strategy.reset()
    return

eatNextSellButtonClicked = ->
    log "eatNextSellButtonClicked"
    strategy.eatNextSell()
    return

eatNextBuyButtonClicked = ->
    log "eatNextBuyButtonClicked"
    strategy.eatNextBuy()
    return
    
module.exports = controlmodule