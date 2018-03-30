json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
# rubocop:disable Metrics/BlockLength
json.data do
  json.followings do
    json.array! followings do |following|
      user = following.following
      json.id user.user_uuid
      json.avatar user.avatar_url
      json.nick_name user.nick_name
      json.gender user.gender
      json.follower_count user.counter.follower_count
      json.following_count user.counter.following_count
    end
  end
  following_ids = followings.map(&:following_id)
  json.followers do
    json.array! followers do |follower|
      user = follower.follower
      json.id user.user_uuid
      json.avatar user.avatar_url
      json.nick_name user.nick_name
      json.gender user.gender
      json.follower_count user.counter.follower_count
      json.following_count user.counter.following_count
      json.is_following following_ids.include?(follower.follower_id)
    end
  end
  json.following_count followings.size
  json.follower_count followers.size
end
