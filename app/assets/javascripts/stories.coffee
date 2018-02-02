# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# last set of stories user has loaded
page = 0;
# number of results to display per page
resPerPage = 30;
# list of all story IDs
stories = [];
# currently pulled stories - store the mto post all at once
allStoryData = [];
# story item index
storyItemIndex = 30;
# whether the program is currently fetching more stories (i.e. don't double up on fetch requests)
isFetching = false;

# Get list of top stories
fetch("https://hacker-news.firebaseio.com/v0/topstories.json").then((resp) => resp.json()).then((resp) => stories = resp)
# .then(() => docReady())

# Detect when user gets to page bottom
window.onscroll = (event) -> 
    if ((window.innerHeight + window.scrollY) >= (document.body.offsetHeight - 10) && !isFetching)
        # get the 30 IDs of stories to load
        lowerBound = page * resPerPage + resPerPage
        upperBound = lowerBound + resPerPage
        pageIDs = stories.slice(lowerBound, upperBound)
        # increment page
        page += 1
        # get story data for requested IDs
        getStories(pageIDs)

# Get the next 30 stories
getStories = (pageIDs) ->
    # page is loading more stories...
    document.getElementById('moreStoriesLink').innerHTML = 'Loading...';
    isFetching = true;

    # get story data
    i = 0
    something = while i < 30
        fetch("https://hacker-news.firebaseio.com/v0/item/#{pageIDs[i]}.json").then((resp) => resp.json()).then((resp) => appendStory(resp))
        i += 1

    # isFetching = false;

appendStory = (storyData) ->
    storiesList = document.getElementById('storiesList')
    newStory = document.createElement('li')
    newStory.className = "storyWrapper clearfix"
    newStory.innerHTML = createStoryLi(storyData)
    storiesList.appendChild(newStory)

    if storyItemIndex == (page * resPerPage) + resPerPage
        isFetching = false
        document.getElementById('moreStoriesLink').innerHTML = 'More';    

createStoryLi = (storyData) ->
    storyItemIndex += 1
    listItemContent = "<p class='storyIndex'>#{storyItemIndex}.</p>
                <a class='voteArrowWrapper' href='http://news.ycombinator.com/item?id=#{storyData.id}><div class='voteArrow'></div></a>
                <div class='storyContentWrapper'>
                    <div class='titleText'>
                        <p><a href=#{storyData.url} class='storyLink'>#{storyData.title}</a><span class='sourceLink'> (<a href='/'>#{createSourceUrl(storyData.url)}</a>)</span></p>
                    </div>
                    <div class='subText'>
                        <p>
                            #{storyData.score} points by 
                            <a href='http://news.ycombinator.com/user?id=#{storyData.by}'>#{storyData.by}</a> 
                            <a href='http://news.ycombinator.com/item?id=#{storyData.id}'>#{createTimeStamp(storyData.time)} hours ago</a> | <a href='http://news.ycombinator.com/hide?id=#{storyData.id}&goto=news'>hide</a> | <a href='http://news.ycombinator.com/item?id=#{storyData.id}'>#{storyData.descendants} comments</a>
                        </p>
                    </div>
                </div>"
    return listItemContent
    
createTimeStamp = (storyTime) ->
    currentTime = Math.round((new Date()).getTime() / 1000)
    secondsSincePost = (currentTime - storyTime)
    hoursSincePost = Math.floor(secondsSincePost / 3600)
    return hoursSincePost
    
createSourceUrl = (storyURL) ->
    if storyURL
        urlTemp = storyURL.split("/")
        return urlTemp[2]
    else
        return "source"