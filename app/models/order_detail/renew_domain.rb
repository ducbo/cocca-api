class OrderDetail::RenewDomain < OrderDetail
  TYPE = 'domain_renew'

  attr_accessor :current_expires_at

  validates :current_expires_at, presence: true

  def save
    return false unless valid?

    client.renew(command).success?
  end

  def command
    EPP::Domain::Renew.new self.domain, self.current_expires_at.in_time_zone, "#{self.period}y"
  end

  def as_json options = nil
    {
      type: self.type,
      price:  0.00,
      domain: self.domain,
      object: nil,
      period: self.period,
      current_expires_at: self.current_expires_at
    }
  end
end
