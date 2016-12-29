# 引入ActiveRecord处理模型相关的工作
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
