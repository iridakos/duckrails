max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

workers ENV.fetch("PUMA_WORKERS") { 3 }
port ENV.fetch("PUMA_LISTEN_PORT") { 3000 }

preload_app!

plugin :tmp_restart

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
