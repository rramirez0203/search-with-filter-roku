' ********** Copyright 2017 Roku Corp.  All Rights Reserved. **********
sub init()
    m.top.functionName = "getContent"
    m.http = NewHttp("", invalid, "GET")
end sub

function GetContent()
    url = "http://www.omdbapi.com/?s=" + URLEncode(m.top.options.query) + "&apikey=26fd4ac7&page=1&type=" + URLEncode(m.top.options.mediatype)
    print "ON GetContent: ", url
    m.http = NewHttp(url, invalid, "GET")
    m.http.AddHeader("Accept", "application/json")
    m.http.AddHeader("Accept-Encoding", "gzip")
    m.http.AddHeader("X-Roku-Reserved-Dev-Id", "")
    rsp = httpGet(m.http, m.top.options.httpType, m.top.options.httpQuantity)
    errorMsg = ""
    status = 0
    if m.http.GetResponseCode () <> 200
        responseCode = m.http.GetResponseCode()
        ? " - API Parser Failed" ; responseCode
        status = 1
    else
        response = ParseJson(rsp)
        print "RESPONSE: ", response
        if response = invalid
            errorMsg = "Unable to parse Json response"
            status = 1
        else if (type(response) <> "roAssociativeArray" and type(response) <> "roArray")
            errorMsg = "Json response is not an associative array"
            status = 1
        else if type(response) = "roAssociativeArray" and response.DoesExist("message")
            errorMsg = GetString(response, "message")
            status = 1
        else
            parseResults(response)            
        end if
    end if
end function

function parseResults(data)
    if data.Response = "True"
        result = createObject("RoSGNode", "ContentNode")
        items = data.Search
        row = result.CreateChild("ContentNode")
        row.title = "Results"
        for each item in items            
            currentItem = row.CreateChild("SearchNode")
            currentItem.labelText = item.Title
            currentItem.posterUrl = item.Poster
            currentItem.mediaType = item.Type
            currentItem.year = item.year
        end for
        m.top.content = result
    else
        result = createObject("RoSGNode", "ErrorNode")
        result.message = data.error
        result.errorType = ":("
        m.top.error = result
    end if
end function