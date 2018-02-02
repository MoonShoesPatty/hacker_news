class StoriesController < ApplicationController
  def index
    # Pull list of top stories
    @storyIDs = HTTParty.get("https://hacker-news.firebaseio.com/v0/topstories.json")

    @storyArray = []
    # Pull story data and store in storyArray
    i = 0
    while i < 30 do
      @storyArray.push(HTTParty.get("https://hacker-news.firebaseio.com/v0/item/#{@storyIDs[i]}.json"))
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
