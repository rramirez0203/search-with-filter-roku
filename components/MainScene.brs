function init()
    m.top.backgroundColor = "#171717"
    m.searchView = m.top.findNode("searchView")
    m.searchView.callFunc("focusKeyboard")
    m.searchView.observeField("keyboardText", "onInput")
    m.searchView.observeField("searching", "onStartSearch")
end function

sub onInput(event)
    print ""
end sub

sub onStartSearch(event)
    if event.getData()
        print "SHOULD START SEARCH", m.searchView.keyboardText
        m.searchTask = CreateObject("roSGNode", "SearchHandler")
        m.searchTask.observeField("content", "onSearchRetrieved")
        m.searchTask.observeField("error", "onError")
        ' m.searchTask.options = { "query": m.searchView.keyboardText, "httpType": "timeout", "httpQuantity": 60 }
        m.searchTask.options = { "query": "the house", "httpType": "timeout", "httpQuantity": 60 }
        m.searchTask.control = "RUN"
    end if
end sub

sub onSearchRetrieved(event)
    data = event.getData()
    PRINT "onSearchRetrieved:", data.
    m.searchView.listData = data
end sub