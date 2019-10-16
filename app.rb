# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"
require "pg"

class Memo
  CONNECTION = PG.connect(host: "153.126.166.203", user: "memo_app", password: "memo", dbname: "memo")

  def self.find(id: id)
    memo = {}
    result = CONNECTION.exec("SELECT * FROM memo WHERE id ='#{id}'")
    result.each do |res|
      memo[:id]    = res["id"]
      memo[:title] = res["title"]
      memo[:body]  = res["body"]
    end
    memo
  end

  def self.create(title: title, body: body)
    contents = { id: SecureRandom.uuid, title: title, body: body }
    CONNECTION.exec("INSERT INTO memo VALUES ('#{contents[:id]}', '#{contents[:title]}', '#{contents[:body]}');")
  end

  def update(id: id, title: title, body: body)
    new_contents = { id: id, title: title, body: body }
    CONNECTION.exec("UPDATE memo SET title = '#{new_contents[:title]}', body = '#{new_contents[:body]}' WHERE id = '#{new_contents[:id]}';")
  end

  def delete(id: id)
    CONNECTION.exec("DELETE FROM memo WHERE id='#{id}'")
  end

  def self.id_list
    CONNECTION.exec("SELECT * FROM memo").field_values("id")
  end
end

get "/memos" do
  @memos  = Memo.id_list.map { |id| Memo.find(id: id) }
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
