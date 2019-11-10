function itemContentChanged() as void
    itemData = m.top.itemContent
    m.itemImage.uri = itemData.posterUrl
    m.itemText.text = itemData.labelText
    m.itemmediaType.text = itemData.mediaType
end function

function init() as void
    print "Inside init"
    m.itemImage = m.top.findNode("itemImage")
    m.itemText = m.top.findNode("itemText")
    m.itemText.font.size = 25
    m.itemmediaType = m.top.findNode("itemmediaType")
    m.itemmediaType.font.size = 20
    print "Leaving init"
end function