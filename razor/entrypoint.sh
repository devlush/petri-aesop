#!/bin/sh
# entrypoint.sh

cat << EOF > /etc/profile.d/rh-ruby26.sh
#!/bin/bash

source /opt/rh/rh-ruby26/enable
export X_SCLS="`scl enable rh-ruby26 'echo $X_SCLS'`"

EOF
chmod +x /etc/profile.d/rh-ruby26.sh

source /opt/rh/rh-ruby26/enable

ruby -e "
  require 'yaml';

  fn = '/etc/puppetlabs/razor-server/config.yaml';
  yom = YAML.load(File.read(fn));

  current_val = yom['production']['database_url'];
  new_val = ENV['DB_URL'];

  fh = File.read(fn);
  puts current_val;
  puts new_val;
  grafted = fh.gsub(current_val, new_val);

  File.open(fn, 'w') {|file| file.puts grafted }
"

