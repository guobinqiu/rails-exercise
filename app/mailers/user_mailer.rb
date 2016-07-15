#http://guides.ruby-china.org/action_mailer_basics.html
class UserMailer < ApplicationMailer
  #SMTP方式
  def welcome_email_smtp(user_id)
    @user = User.find(user_id)
    email_with_name = "#{@user.name} <#{@user.email}>"

    mail(to: email_with_name, subject: 'Welcome', template_path: 'user_mailer', template_name: 'welcome_email')
  end

  #HTTP方式
  def welcome_email_http(user_id)
    @user = User.find(user_id)
    email_with_name = "#{@user.name} <#{@user.email}>"

    key = 'key-0i6nmq2wv9bhxi9ts3qh3dy8fe-2wne5'
    domain = 'diningcity.hk'
    url = "https://api:#{key}@api.mailgun.net/v3/#{domain}/messages"

    data = {}
    data[:from] = "Guobin <no-reply@diningcity.hk>"
    data[:to] = email_with_name
    #data[:cc] = "baz@example.com"
    #data[:bcc] = "bar@example.com"
    data[:subject] = "Welcome"
    #data[:text] = "Testing some Mailgun awesomness!"
    html_output = render_to_string template: 'user_mailer/welcome_email'
    data[:html] = html_output.to_str

    begin
      RestClient.post url, data
    rescue Exception => e
      throw e
    end
  end
end
