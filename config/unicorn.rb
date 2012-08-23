graphiti_root = File.join(File.dirname(__FILE__), '..')

listen 5001 # by default Unicorn listens on port 8080
worker_processes 2 # this should be >= nr_cpus
pid "#{graphiti_root}/tmp/pids/unicorn.pid"
stderr_path "#{graphiti_root}/log/unicorn.log"
stdout_path "#{graphiti_root}/log/unicorn.log"
