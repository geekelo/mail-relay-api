require "mail"

class EmailsController < ApplicationController
  def send_email
    to      = params[:to]
    subject = params[:subject]
    body    = params[:body]

    options = {
      address: ENV["SMTP_ADDRESS"],
      port: ENV["SMTP_PORT"].to_i,
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      authentication: "login",
      enable_starttls_auto: true,
      domain: ENV["SMTP_DOMAIN"]
    }

    Mail.defaults do
      delivery_method :smtp, options
    end

    Mail.deliver do
      to to
      from ENV["SMTP_USERNAME"]
      subject subject
      body body
    end

    render json: { status: "sent", to: to, subject: subject }
  rescue => e
    render json: { status: "error", error: e.message }, status: 500
  end
end
