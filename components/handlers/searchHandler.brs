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
            print item
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

' function parseTrending(response)
'     result = createObject("RoSGNode", "ContentNode")

'     if response.DoesExist("items")

'         items = getArray(response, "items")
'         first = true
'         for i = 0 to items.Count() - 1 step 1
'             item = items[i]
'             row = CreateObject("roSGNode", "RowNode")
'             if first then row.title = "Trending Searches" else row.title = ""
'             first = false
'             card = itemToNode(parseItem(item, "card"))
'             row.appendChild(card)
'             result.appendChild(row)
'             REM EXIT FOR when reach 5 elements
'             if i >= 4 then exit for
'         end for
'         m.top.content = result
'     else
'         m.top.content = result
'     end if
'     ' m.top.content = sections
' end function

' function HasRecentSearches()
'     recentSearches = RegRead("recentSearches")
'     if recentSearches <> invalid and ParseJson(recentSearches).count() > 0 then return true
'     return false
' end function

' function parseRecentSearches()
'     result = createObject("RoSGNode", "ContentNode")
'     recentSearches = ParseJson(RegRead("recentSearches"))

'     if m.validated <> invalid and m.validated
'         first = true
'         for each item in recentSearches
'             row = CreateObject("roSGNode", "RowNode")
'             if first then row.title = "Recent Searches" else row.title = ""
'             first = false
'             card = itemToNode(item)
'             row.appendChild(card)
'             result.appendChild(row)
'         end for

'         buttonRow = CreateObject("roSGNode", "RowNode")
'         button = CreateObject("roSGNode", "ItemNode")
'         button.itemType = "button"
'         buttonRow.appendChild(button)
'         result.appendChild(buttonRow)
'         m.top.content = result
'     else
'         getSearchIndex()
'     end if
' end function


' sub getSearchIndex()
'     url = m.api.searchCatalog
'     m.http = NewHttp(url, invalid, "GET")
'     m.http.AddHeader("Accept", "application/json")
'     m.http.AddHeader("Accept-Encoding", "gzip")
'     m.http.AddHeader("X-Roku-Reserved-Dev-Id", "")
'     rsp = httpGet(m.http, m.top.options.httpType, m.top.options.httpQuantity)

'     errorMsg = ""
'     status = 0

'     if m.http.GetResponseCode () <> 200
'         responseCode = m.http.GetResponseCode()
'         ? " - API Parser Failed" ; responseCode
'         ' if responseCode = 404
'         '   response = ParseJson(rsp)
'         '   if type(response) = "roAssociativeArray" and response.DoesExist("message")
'         '       errorMsg = GetString(response,"message")
'         status = 1
'         '   end if
'         ' end if
'     else
'         response = ParseJson(rsp)
'         if response = invalid
'             errorMsg = "Unable to parse Json response"
'             status = 1
'         else if (type(response) <> "roAssociativeArray" and type(response) <> "roArray")
'             errorMsg = "Json response is not an associative array"
'             status = 1
'         else if type(response) = "roAssociativeArray" and response.DoesExist("message")
'             errorMsg = GetString(response, "message")
'             status = 1
'         else
'             m.searchIndex = []
'             m.searchIndex.Append(response.shows)
'             m.searchIndex.Append(response.movies)
'             recentSearches = ParseJson(RegRead("recentSearches"))
'             index = 0
'             for each item in recentSearches
'                 indexOfRecentSearch = getIndexOfByProperty(m.searchIndex, "partner_api_id", item.partnerApiId)
'                 if indexOfRecentSearch = -1 and getString(item, "partnerApiId") <> ""
'                     recentSearches.Delete(index)
'                 end if
'                 index ++
'             end for
'             formatRecentSearches = FormatJson(recentSearches)
'             RegWrite("recentSearches", formatRecentSearches)
'             m.validated = true
'             GetContent()
'         end if
'     end if
'     if status = 1
'         ' errorContent = createObject("RoSGNode", "ErrorNode")
'         ' errorContent.code =  m.top.type
'         ' errorContent.msg =  errorMsg
'         ' m.top.error = errorContent
'     end if

' end sub

' function saveRecentSearches()
'     recentSearch = nodeToItem(m.top.selectedContent)
'     if HasRecentSearches()
'         recentSearches = ParseJson(RegRead("recentSearches"))
'         if recentSearch.partnerApiId <> ""
'             indexOfRecentSearch = getIndexOfByProperty(recentSearches, "partnerApiId", recentSearch.partnerApiId)
'         else
'             indexOfRecentSearch = invalid
'         end if
'         indexOfRecentSearchDeeplink = getIndexOfByProperty(recentSearches, "appDeepLink", recentSearch.appDeepLink)
'         REM LIMIT TO 5 RECENT SEARCHES
'         if (indexOfRecentSearch <> invalid and indexOfRecentSearch = -1) or indexOfRecentSearchDeeplink = -1
'             if recentSearches.Count() = 5
'                 recentSearches.pop()
'             end if
'         else
'             if indexOfRecentSearch <> invalid
'                 recentSearches.Delete(indexOfRecentSearch)
'             else
'                 recentSearches.Delete(indexOfRecentSearchDeeplink)
'             end if
'         end if
'         recentSearches.Unshift(recentSearch)
'         formatRecentSearches = FormatJson(recentSearches)
'         RegWrite("recentSearches", formatRecentSearches)
'     else
'         formatRecentSearches = FormatJson([recentSearch])
'         RegWrite("recentSearches", formatRecentSearches)
'     end if
' end function
