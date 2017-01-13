# 发送邮件短信验证码任务
class SendEmailSmsJob < ApplicationJob
  queue_as :default

  def perform(sms_type, email, content)
    logger = Resque.logger
    logger.info "[SendEmailSmsJob] Send #{sms_type} SMS to #{email}: #{content}]"
  end
end
