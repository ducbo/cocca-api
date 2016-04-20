class DeleteDomainJob < ApplicationJob
  URL = Rails.configuration.x.registry_url

  queue_as :sync_cocca_records

  def perform record
    execute :delete, path: "#{URL}/domains/#{record[:domain]}"
  end
end