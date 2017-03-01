json.user_extra do
  json.real_name          user_extra.real_name.to_s
  json.cert_no            user_extra.cert_no.to_s
  json.status             user_extra.status.to_s
  json.image              user_extra.image_path.to_s
end