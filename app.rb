# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

class Memo
  def self.find(id: id)
    JSON.parse(File.read("memos/#{id}.json"), symbolize_names: true)
  end

  def self.create(title: title, body: body)
    contents = { id: SecureRandom.uuid, title: title, body: body }
    File.open("memos/#{contents[:id]}.json", "w") { |file| file.puts JSON.pretty_generate(contents) }
  end

  def update(id: id, title: title, body: body)
    new_contents = { id: id, title: title, body: body }
    File.open("memos/#{id}.json", "w") { |file| file.puts JSON.pretty_generate(new_contents) }
  end

  def delete(id: id)
    File.delete("memos/#{id}.json")
  end
end

get "/memos" do
  file_list = Dir.glob("memos/*")
  @memos = file_list.map { |file| JSON.parse(File.read(file), symbolize_names: true) }
  erb :top
end

get "/memos/new" do
  erb :new
end

post "/memos/new" do
  Memo.create(title: params[:title], body: params[:body])
  redirect "/memos"
end

get "/memos/:id" do
  @memo = Memo.find(id: params[:id])
  erb :memo
end

get "/memos/:id/edit" do
  @memo = Memo.find(id: params[:id])
  erb :edit
end

patch "/memos/:id" do
  Memo.new.update(id: params[:id], title: params[:title], body: params[:body])
  redirect "/memos"
  erb :edit
end

delete "/memos/:id" do
  Memo.new.delete(id: params[:id])
  redirect "/memos"
end
