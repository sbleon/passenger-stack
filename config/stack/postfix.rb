package :postfix, :provides => :smtp do
  description "Postfix SMTP server for outgoing mail"

  apt 'postfix'

  verify do
    has_apt 'postfix'
  end
end