class StoriesController < ApplicationController
  def index
    @storyIDs = HTTParty.get("https://hacker-news.firebaseio.com/v0/topstories.json")

    # @storyIDs.each do |story|
      @storyItem = HTTParty.get("https://hacker-news.firebaseio.com/v0/item/#{@storyIDs[0]}.json")
      puts @storyItem

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
