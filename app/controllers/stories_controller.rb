class StoriesController < ApplicationController
  def index
    # Pull list of top stories
    @storyIDs = HTTParty.get("https://hacker-news.firebaseio.com/v0/topstories.json")

    @storyArray = []
    # Pull story data and store in storyArray
    i = 0
    while i < 3 do
      currentStory = HTTParty.get("https://hacker-news.firebaseio.com/v0/item/#{@storyIDs[i]}.json")

      # Calculate hours since story was posted
      secondsSincePost = ((Time.now.to_i - currentStory["time"]))
      hoursSincePost = secondsSincePost / 3600
      currentStory["timeStamp"] = hoursSincePost.floor

      puts currentStory
      # Shorten URL to main source website
      if currentStory["url"]
        urlTemp = currentStory["url"].split("/")
        urlTemp[2].gsub! "www.", ""
        currentStory["urlShort"] = urlTemp[2]
      else 
        currentStory["urlShort"] = "source"
      end

      @storyArray.push(currentStory)
      i += 1
    end
      # by = story.by
      # descendants = story.descendants
      # post_id = story.post_id
      # kids = story.kids
      # score = story.score
      # text = story.text
      # time = story.time
      # title = story.title
      # type = story.type
      # url = story.url
    # end
  end
end
