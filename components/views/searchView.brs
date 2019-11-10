sub init()
    m.top.observeField("keyboardText", "onInput")
    print "SEARCH VIEW -> init"
    m.currentFilter = 0 '0=ALL,1=MOVIES,2=SERIES
    m.searchKeyboard = m.top.findNode("searchKeyboard")
    m.labelText = m.top.findNode("LabelText")
    m.labelText.font.size = 50
    m.inputTimer = m.top.findNode("inputTimer")
    m.searchList = m.top.findNode("searchList")
    m.noResultsLabel = m.top.findNode("noResultsLabel")
    m.searchListFilters = m.top.findNode("searchListFilters")
    m.inputTimer.ObserveField("fire", "search")
    m.top.observeField("listData", "onListContentChange")
    m.top.observeField("filterSelected", "onFilterSelected")
    createFilters()
    m.filters = ["", "movie", "series"]
end sub

sub focusKeyboard()
    m.searchKeyboard.setFocus(true)
end sub

sub focusList()
    m.searchList.setFocus(true)
end sub

sub focusFilters()
    m.searchListFilters.setFocus(true)
end sub

sub CANCEL()
    ? "@@@@@@@@ cancel @@@@@@@@"
    m.inputTimer.control = "stop"
    m.top.searching = false
end sub

sub search()
    ? "@@@@@@@@ search @@@@@@@@"
    ' m.searchlist.content = invalid
    ' m.searchList.visible = false
    ' m.searchList.jumpToRowItem = [0, 0]
    ' m.top.showSpinner = true
    m.noResultsLabel.visible = false
    m.top.searching = true
end sub

sub onInput(event)
    ? "@@@@@@@@ onInput @@@@@@@@"
    m.labelText.text = event.getData()
    CANCEL()
    if Len(m.top.keyboardText) >= 1
        m.inputTimer.control = "start"
    end if
end sub

sub displayErrors(isVisible = true, error = {message: "No results availables :/"})
    print "@@@@@@@@ display errors @@@@@@@@", error
    m.noResultsLabel.text = error.message
    m.noResultsLabel.visible = isVisible
end sub

sub onListContentChange(event)
    data = event.getData()
    print "####### onListContentChange #######", data
    if data.doesExist("isError") and data.isError
        m.searchList.visible = false
        displayErrors(true, data)
    else
        displayErrors(false)
        m.searchList.visible = true
        m.searchList.content = data
    end if
    m.top.searching = false
end sub

sub createFilters()
    print "@@@@@ createFilters @@@@@"
    data = CreateObject("roSGNode", "ContentNode")
    items = [
        { title: "all", selected: true },
        { title: "movies", selected: false },
        { title: "series", selected: false }
    ]
    row = data.CreateChild("ContentNode")
    for each currentItem in items
        item = row.CreateChild("SearchFilterNode")
        item.labeltext = currentItem.title
        item.isselected = currentItem.selected
        print currentItem, item
    end for
    m.searchListFilters.content = data
end sub


function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if press and m.top.isInFocusChain()
        if key = "up" and m.searchKeyboard.isInFocusChain()
            focusFilters()
            handled = true
        else if key = "down" and m.searchListFilters.isInFocusChain()
            focusKeyboard()
            handled = true
        else if key = "left" and m.searchList.hasFocus()
            focusKeyboard()
            handled = true
        else if key = "right" and m.searchKeyboard.isInFocusChain() and not m.top.searching and m.searchList.content <> invalid and m.searchList.visible
            focusList()
            handled = true
        else if key = "back"
            m.searchList.jumpToRowItem = 0
            handled = true
        end if
    end if
    return handled
end function

sub onFilterSelected(event)
    itemIndex = event.getData()[1]
    rowContent = m.searchListFilters.content.getChild(0)
    rowContent.getChild(m.currentFilter).isselected = false
    m.currentFilter = itemIndex
    rowContent.getChild(itemIndex).isselected = true
    m.top.currentFilter = m.filters[itemIndex]
    search()
end sub