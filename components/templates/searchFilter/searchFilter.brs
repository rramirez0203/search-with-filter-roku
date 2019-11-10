sub init()
    m.rectangle = m.top.findNode("rectangle")
    m.itemText = m.top.findNode("itemText")
end sub

sub itemContentChanged()
    itemData = m.top.itemContent
    m.itemText.text = itemData.labelText
    if itemData.isSelected
        m.rectangle.color = "#FFFFFF"
        m.itemText.color = "#000000"
    else
        m.rectangle.color = "#FFFFFF1A"
        m.itemText.color = "#FFFFFF"
    end if
end sub