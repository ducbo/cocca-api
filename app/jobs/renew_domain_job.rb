class RenewDomainJob < ApplicationJob
  URL = Rails.configuration.x.registry_url

  queue_as :sync_cocca_records

  def perform record
    json_request = {
      partner:        record[:partner],
      currency_code:  'USD',
      ordered_at:     record[:ordered_at],
      order_details:  [
        {
          type:  'domain_renew',
          domain: record[:domain],
          period: record[:period]
        }
      ]
    }

    execute :post, partner: record[:partner], path: "#{URL}/orders", body: json_request
  end
end
