#!/bin/bash
set -e

# Puppet task for executing Ansible role: ansible_role_mysql
# This script runs the entire role via ansible-playbook

# Determine the ansible modules directory
if [ -n "$PT__installdir" ]; then
  ANSIBLE_DIR="$PT__installdir/lib/puppet_x/ansible_modules/ansible_role_mysql"
else
  # Fallback to /opt/puppetlabs/puppet/cache/lib/puppet_x/ansible_modules
  ANSIBLE_DIR="/opt/puppetlabs/puppet/cache/lib/puppet_x/ansible_modules/ansible_role_mysql"
fi

# Check if ansible-playbook is available
if ! command -v ansible-playbook &> /dev/null; then
  echo '{"_error": {"msg": "ansible-playbook command not found. Please install Ansible.", "kind": "puppet-ansible-converter/ansible-not-found"}}'
  exit 1
fi

# Check if the role directory exists
if [ ! -d "$ANSIBLE_DIR" ]; then
  echo "{\"_error\": {\"msg\": \"Ansible role directory not found: $ANSIBLE_DIR\", \"kind\": \"puppet-ansible-converter/role-not-found\"}}"
  exit 1
fi

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
if [ -d "$ANSIBLE_DIR/roles" ] && [ -f "$ANSIBLE_DIR/roles/paw_ansible_role_mysql/playbook.yml" ]; then
  # Collection structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/roles/paw_ansible_role_mysql/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR/roles/paw_ansible_role_mysql"
elif [ -f "$ANSIBLE_DIR/playbook.yml" ]; then
  # Standalone role structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR"
else
  echo "{\"_error\": {\"msg\": \"playbook.yml not found in $ANSIBLE_DIR or $ANSIBLE_DIR/roles/paw_ansible_role_mysql\", \"kind\": \"puppet-ansible-converter/playbook-not-found\"}}"
  exit 1
fi

# Build extra-vars from PT_* environment variables (excluding par_* control params)
EXTRA_VARS="{"
FIRST=true
if [ -n "$PT_mysql_port" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_port\": \"$PT_mysql_port\""
fi
if [ -n "$PT_mysql_socket" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_socket\": \"$PT_mysql_socket\""
fi
if [ -n "$PT_mysql_bind_address" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_bind_address\": \"$PT_mysql_bind_address\""
fi
if [ -n "$PT_mysql_datadir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_datadir\": \"$PT_mysql_datadir\""
fi
if [ -n "$PT_mysql_pid_file" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_pid_file\": \"$PT_mysql_pid_file\""
fi
if [ -n "$PT_mysql_sql_mode" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_sql_mode\": \"$PT_mysql_sql_mode\""
fi
if [ -n "$PT_mysql_syslog_tag" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_syslog_tag\": \"$PT_mysql_syslog_tag\""
fi
if [ -n "$PT_mysql_log" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_log\": \"$PT_mysql_log\""
fi
if [ -n "$PT_mysql_log_error" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_log_error\": \"$PT_mysql_log_error\""
fi
if [ -n "$PT_mysql_slow_query_log_file" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_slow_query_log_file\": \"$PT_mysql_slow_query_log_file\""
fi
if [ -n "$PT_mysql_slow_query_time" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_slow_query_time\": \"$PT_mysql_slow_query_time\""
fi
if [ -n "$PT_mysql_server_id" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_server_id\": \"$PT_mysql_server_id\""
fi
if [ -n "$PT_mysql_expire_logs_days" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_expire_logs_days\": \"$PT_mysql_expire_logs_days\""
fi
if [ -n "$PT_mysql_max_binlog_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_max_binlog_size\": \"$PT_mysql_max_binlog_size\""
fi
if [ -n "$PT_mysql_binlog_format" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_binlog_format\": \"$PT_mysql_binlog_format\""
fi
if [ -n "$PT_mysql_key_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_key_buffer_size\": \"$PT_mysql_key_buffer_size\""
fi
if [ -n "$PT_mysql_max_allowed_packet" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_max_allowed_packet\": \"$PT_mysql_max_allowed_packet\""
fi
if [ -n "$PT_mysql_table_open_cache" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_table_open_cache\": \"$PT_mysql_table_open_cache\""
fi
if [ -n "$PT_mysql_sort_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_sort_buffer_size\": \"$PT_mysql_sort_buffer_size\""
fi
if [ -n "$PT_mysql_read_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_read_buffer_size\": \"$PT_mysql_read_buffer_size\""
fi
if [ -n "$PT_mysql_read_rnd_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_read_rnd_buffer_size\": \"$PT_mysql_read_rnd_buffer_size\""
fi
if [ -n "$PT_mysql_myisam_sort_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_myisam_sort_buffer_size\": \"$PT_mysql_myisam_sort_buffer_size\""
fi
if [ -n "$PT_mysql_thread_cache_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_thread_cache_size\": \"$PT_mysql_thread_cache_size\""
fi
if [ -n "$PT_mysql_query_cache_type" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_query_cache_type\": \"$PT_mysql_query_cache_type\""
fi
if [ -n "$PT_mysql_query_cache_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_query_cache_size\": \"$PT_mysql_query_cache_size\""
fi
if [ -n "$PT_mysql_query_cache_limit" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_query_cache_limit\": \"$PT_mysql_query_cache_limit\""
fi
if [ -n "$PT_mysql_max_connections" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_max_connections\": \"$PT_mysql_max_connections\""
fi
if [ -n "$PT_mysql_tmp_table_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_tmp_table_size\": \"$PT_mysql_tmp_table_size\""
fi
if [ -n "$PT_mysql_max_heap_table_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_max_heap_table_size\": \"$PT_mysql_max_heap_table_size\""
fi
if [ -n "$PT_mysql_group_concat_max_len" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_group_concat_max_len\": \"$PT_mysql_group_concat_max_len\""
fi
if [ -n "$PT_mysql_join_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_join_buffer_size\": \"$PT_mysql_join_buffer_size\""
fi
if [ -n "$PT_mysql_wait_timeout" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_wait_timeout\": \"$PT_mysql_wait_timeout\""
fi
if [ -n "$PT_mysql_lower_case_table_names" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_lower_case_table_names\": \"$PT_mysql_lower_case_table_names\""
fi
if [ -n "$PT_mysql_event_scheduler_state" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_event_scheduler_state\": \"$PT_mysql_event_scheduler_state\""
fi
if [ -n "$PT_mysql_innodb_large_prefix" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_large_prefix\": \"$PT_mysql_innodb_large_prefix\""
fi
if [ -n "$PT_mysql_innodb_file_format" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_file_format\": \"$PT_mysql_innodb_file_format\""
fi
if [ -n "$PT_mysql_innodb_file_per_table" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_file_per_table\": \"$PT_mysql_innodb_file_per_table\""
fi
if [ -n "$PT_mysql_innodb_buffer_pool_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_buffer_pool_size\": \"$PT_mysql_innodb_buffer_pool_size\""
fi
if [ -n "$PT_mysql_innodb_log_file_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_log_file_size\": \"$PT_mysql_innodb_log_file_size\""
fi
if [ -n "$PT_mysql_innodb_log_buffer_size" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_log_buffer_size\": \"$PT_mysql_innodb_log_buffer_size\""
fi
if [ -n "$PT_mysql_innodb_flush_log_at_trx_commit" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_flush_log_at_trx_commit\": \"$PT_mysql_innodb_flush_log_at_trx_commit\""
fi
if [ -n "$PT_mysql_innodb_lock_wait_timeout" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_innodb_lock_wait_timeout\": \"$PT_mysql_innodb_lock_wait_timeout\""
fi
if [ -n "$PT_mysql_mysqldump_max_allowed_packet" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_mysqldump_max_allowed_packet\": \"$PT_mysql_mysqldump_max_allowed_packet\""
fi
if [ -n "$PT_mysql_config_include_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_config_include_dir\": \"$PT_mysql_config_include_dir\""
fi
if [ -n "$PT_mysql_root_username" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_root_username\": \"$PT_mysql_root_username\""
fi
if [ -n "$PT_mysql_root_password" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_root_password\": \"$PT_mysql_root_password\""
fi
if [ -n "$PT_mysql_user_name" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_user_name\": \"$PT_mysql_user_name\""
fi
if [ -n "$PT_mysql_user_password" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_user_password\": \"$PT_mysql_user_password\""
fi
if [ -n "$PT_mysql_user_home" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_user_home\": \"$PT_mysql_user_home\""
fi
if [ -n "$PT_mysql_root_home" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_root_home\": \"$PT_mysql_root_home\""
fi
if [ -n "$PT_mysql_root_password_update" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_root_password_update\": \"$PT_mysql_root_password_update\""
fi
if [ -n "$PT_mysql_user_password_update" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_user_password_update\": \"$PT_mysql_user_password_update\""
fi
if [ -n "$PT_mysql_enabled_on_startup" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_enabled_on_startup\": \"$PT_mysql_enabled_on_startup\""
fi
if [ -n "$PT_overwrite_global_mycnf" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"overwrite_global_mycnf\": \"$PT_overwrite_global_mycnf\""
fi
if [ -n "$PT_mysql_copy_root_user_mycnf" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_copy_root_user_mycnf\": \"$PT_mysql_copy_root_user_mycnf\""
fi
if [ -n "$PT_mysql_enablerepo" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_enablerepo\": \"$PT_mysql_enablerepo\""
fi
if [ -n "$PT_mysql_python_package_debian" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_python_package_debian\": \"$PT_mysql_python_package_debian\""
fi
if [ -n "$PT_mysql_skip_name_resolve" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_skip_name_resolve\": \"$PT_mysql_skip_name_resolve\""
fi
if [ -n "$PT_mysql_log_file_group" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_log_file_group\": \"$PT_mysql_log_file_group\""
fi
if [ -n "$PT_mysql_slow_query_log_enabled" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_slow_query_log_enabled\": \"$PT_mysql_slow_query_log_enabled\""
fi
if [ -n "$PT_mysql_config_include_files" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_config_include_files\": \"$PT_mysql_config_include_files\""
fi
if [ -n "$PT_mysql_databases" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_databases\": \"$PT_mysql_databases\""
fi
if [ -n "$PT_mysql_users" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_users\": \"$PT_mysql_users\""
fi
if [ -n "$PT_mysql_disable_log_bin" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_disable_log_bin\": \"$PT_mysql_disable_log_bin\""
fi
if [ -n "$PT_mysql_replication_role" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_replication_role\": \"$PT_mysql_replication_role\""
fi
if [ -n "$PT_mysql_replication_master" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_replication_master\": \"$PT_mysql_replication_master\""
fi
if [ -n "$PT_mysql_replication_master_inventory_host" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_replication_master_inventory_host\": \"$PT_mysql_replication_master_inventory_host\""
fi
if [ -n "$PT_mysql_replication_user" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_replication_user\": \"$PT_mysql_replication_user\""
fi
if [ -n "$PT_mysql_hide_passwords" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"mysql_hide_passwords\": \"$PT_mysql_hide_passwords\""
fi
EXTRA_VARS="$EXTRA_VARS}"

# Build ansible-playbook command matching PAR provider exactly
# See: https://github.com/garrettrowell/puppet-par/blob/main/lib/puppet/provider/par/par.rb#L166
cd "$PLAYBOOK_DIR"

# Base command with inventory and connection (matching PAR)
ANSIBLE_CMD="ansible-playbook -i localhost, --connection=local"

# Add extra-vars (playbook variables)
ANSIBLE_CMD="$ANSIBLE_CMD -e \"$EXTRA_VARS\""

# Add tags if specified
if [ -n "$PT_par_tags" ]; then
  TAGS=$(echo "$PT_par_tags" | sed 's/\[//;s/\]//;s/"//g;s/,/,/g')
  ANSIBLE_CMD="$ANSIBLE_CMD --tags \"$TAGS\""
fi

# Add skip-tags if specified
if [ -n "$PT_par_skip_tags" ]; then
  SKIP_TAGS=$(echo "$PT_par_skip_tags" | sed 's/\[//;s/\]//;s/"//g;s/,/,/g')
  ANSIBLE_CMD="$ANSIBLE_CMD --skip-tags \"$SKIP_TAGS\""
fi

# Add start-at-task if specified
if [ -n "$PT_par_start_at_task" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --start-at-task \"$PT_par_start_at_task\""
fi

# Add limit if specified
if [ -n "$PT_par_limit" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --limit \"$PT_par_limit\""
fi

# Add verbose flag if specified
if [ "$PT_par_verbose" = "true" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD -v"
fi

# Add check mode flag if specified
if [ "$PT_par_check_mode" = "true" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --check"
fi

# Add user if specified
if [ -n "$PT_par_user" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --user \"$PT_par_user\""
fi

# Add timeout if specified
if [ -n "$PT_par_timeout" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --timeout $PT_par_timeout"
fi

# Add playbook path as last argument (matching PAR)
ANSIBLE_CMD="$ANSIBLE_CMD playbook.yml"

# Set environment variables if specified (matching PAR env_vars handling)
if [ -n "$PT_par_env_vars" ]; then
  # Parse JSON hash and export variables
  eval $(echo "$PT_par_env_vars" | sed 's/[{}]//g;s/": "/=/g;s/","/;export /g;s/"//g' | sed 's/^/export /')
fi

# Set required Ansible environment (matching PAR)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ANSIBLE_STDOUT_CALLBACK=json

# Execute ansible-playbook
eval $ANSIBLE_CMD 2>&1

EXIT_CODE=$?

# Return JSON result
if [ $EXIT_CODE -eq 0 ]; then
  echo '{"status": "success", "role": "ansible_role_mysql"}'
else
  echo "{\"status\": \"failed\", \"role\": \"ansible_role_mysql\", \"exit_code\": $EXIT_CODE}"
fi

exit $EXIT_CODE
