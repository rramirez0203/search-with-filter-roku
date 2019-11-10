sub init()
    m.top.observeField("keyboardText", "onInput")
    print "SEARCH VIEW -> init"
    m.searchKeyboard = m.top.findNode("searchKeyboard")
    m.labelText = m.top.findNode("LabelText")
    m.inputTimer = m.top.findNode("inputTimer")
    m.searchList = m.top.findNode("searchList")
    m.inputTimer.ObserveField("fire", "search")
    m.top.observeField("listData", "onListContentChange")
end sub

sub focusKeyboard()
    m.searchKeyboard.setFocus(true)
end sub

sub CANCEL()
    ? "cancel"
    m.inputTimer.control = "stop"
    m.top.searching = false
end sub

sub search()
    ? "search"
    ' m.searchlist.content = invalid
    ' m.searchList.visible = false
    ' m.searchList.jumpToRowItem = [0, 0]
    ' m.top.showSpinner = true
    m.top.searching = true
end sub

sub onInput(event)    
    m.labelText.text = event.getData()
    CANCEL()
    if Len(m.top.keyboardText) >= 1
        m.inputTimer.control = "start"    
    end if
end sub

sub onListContentChange(event)
    print "####### onListContentChange #######"
    data = event.getData()
    m.searchList.content = data
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    ' print "KEY:", key
    ' print "Press:", press
    '   if press and m.top.isInFocusChain()
    '       if key = "play" and m.searchList.hasFocus()
    '         if m.searchList.content <> invalid and m.searchList.content.getChild(m.searchList.rowItemFocused[0]).getChild(m.searchList.rowItemFocused[1]) <> invalid
    '           m.top.triggerByPlay = true
    '           m.top.itemSelected  = m.searchlist.rowItemFocused
    '         end if
    '     else if key = "left" and m.searchList.hasFocus()
    '       ' m.movingFromOtherPlace = true
    '       ' m.allCollectionsItems.setFocus(false)
    '       focusKeyboard()
    '       ' m.allCollectionsItems.setFocus(false)
    '       ' m.allCollectionsSections.setFocus(true)
    '       ' m.focusSectionsTimer.control = "Start"
    '       ' focusSections()
    '       handled = true
    '     else if key = "right" and m.searchKeyboard.isInFocusChain() and not m.top.searching and m.searchList.content <> invalid and m.searchList.visible
    '       ' m.movingFromOtherPlace = true
    '       focusList()
    '       ' m.allCollectionsSections.setFocus(false)
    '       handled = true
    '     else if key = "back" or  key = "options" or key = "up"
    '       m.top.showHeader  = true
    '       m.top.focusHeader = true
    '       handled = true
    '     end if
    '    end if
    return handled
end function