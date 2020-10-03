indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.display = document.getElementById("display")
    global.latestPriceDisplay = document.getElementById("latest-price-display")
    global.sellHeadDisplay = document.getElementById("sell-head-display")
    global.buyHeadDisplay = document.getElementById("buy-head-display")
    global.primaryAssetDifDisplay = document.getElementById("primary-asset-dif-display")
    global.secondaryAssetDifDisplay = document.getElementById("secondary-asset-dif-display")
    global.resetButton = document.getElementById("reset-button")
    global.eatNextSellButton = document.getElementById("eat-next-sell-button")
    global.eatNextBuyButton = document.getElementById("eat-next-buy-button")
    return
    
module.exports = indexdomconnect