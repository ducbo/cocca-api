role :app, %w{deploy@cocca-api.staging.local}

role :resque_worker, %w{deploy@cocca-api.staging.local}
role :resque_scheduler, %w{deploy@cocca-api.staging.local}
