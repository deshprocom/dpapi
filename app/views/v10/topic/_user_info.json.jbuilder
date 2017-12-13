json.user_id resource.user.user_uuid
json.nick_name resource.user.nick_name.to_s
json.avatar resource.user.avatar_path.to_s
json.official resource.user.role.eql?('official')