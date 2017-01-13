# 发送短信验证码任务
class SendMobileSmsJob < ApplicationJob
  queue_as :default

  def perform(sms_type, mobile, content, gateway = 'test')
    logger = Resque.logger
    logger.info "[SendMobileSmsJob] Send #{sms_type} SMS to #{mobile} via gateway [#{gateway}: #{content}]"
  end
end
