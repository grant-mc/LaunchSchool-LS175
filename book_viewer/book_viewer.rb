require "sinatra"
require "sinatra/reloader"

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
  end


  def highlight(text, query)
    text.gsub(query, "<strong>#{query}</strong>")
  end

  def each_chapter
    @contents.each_with_index do |name, idx|
      num = idx + 1
      contents = File.read("data/chp#{num}.txt")
      yield num, name, contents
    end
  end

  def chapters_matching(query)
    results = []

    return results unless query

    each_chapter do |number, name, contents|
      matches = {}
      contents.split("\n\n").each_with_index do |paragraph, idx|
        matches[idx] = paragraph if paragraph.include?(query)
      end
      results << {number: number, name: name, paragraphs: matches} if matches.any?
    end

    results
  end


end

not_found do
  redirect "/"
end

before do
  @contents =  File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  name_of_chapter = @contents[number -1]

  redirect "/" unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{name_of_chapter}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

