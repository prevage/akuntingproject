json.array!(@posts) do |post|
  json.extract! post, :id , :content, :profile_id
  json.user post.profile, :fname, :lname
  json.created_at time_ago_in_words(post.created_at)
  
end