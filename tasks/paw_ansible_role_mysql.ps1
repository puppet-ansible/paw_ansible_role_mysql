# Puppet task for executing Ansible role: ansible_role_mysql
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_mysql"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_mysql"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_mysql\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_mysql"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_mysql"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_mysql_port) {
  $ExtraVars['mysql_port'] = $env:PT_mysql_port
}
if ($env:PT_mysql_socket) {
  $ExtraVars['mysql_socket'] = $env:PT_mysql_socket
}
if ($env:PT_mysql_bind_address) {
  $ExtraVars['mysql_bind_address'] = $env:PT_mysql_bind_address
}
if ($env:PT_mysql_datadir) {
  $ExtraVars['mysql_datadir'] = $env:PT_mysql_datadir
}
if ($env:PT_mysql_pid_file) {
  $ExtraVars['mysql_pid_file'] = $env:PT_mysql_pid_file
}
if ($env:PT_mysql_sql_mode) {
  $ExtraVars['mysql_sql_mode'] = $env:PT_mysql_sql_mode
}
if ($env:PT_mysql_syslog_tag) {
  $ExtraVars['mysql_syslog_tag'] = $env:PT_mysql_syslog_tag
}
if ($env:PT_mysql_log) {
  $ExtraVars['mysql_log'] = $env:PT_mysql_log
}
if ($env:PT_mysql_log_error) {
  $ExtraVars['mysql_log_error'] = $env:PT_mysql_log_error
}
if ($env:PT_mysql_slow_query_log_file) {
  $ExtraVars['mysql_slow_query_log_file'] = $env:PT_mysql_slow_query_log_file
}
if ($env:PT_mysql_slow_query_time) {
  $ExtraVars['mysql_slow_query_time'] = $env:PT_mysql_slow_query_time
}
if ($env:PT_mysql_server_id) {
  $ExtraVars['mysql_server_id'] = $env:PT_mysql_server_id
}
if ($env:PT_mysql_expire_logs_days) {
  $ExtraVars['mysql_expire_logs_days'] = $env:PT_mysql_expire_logs_days
}
if ($env:PT_mysql_max_binlog_size) {
  $ExtraVars['mysql_max_binlog_size'] = $env:PT_mysql_max_binlog_size
}
if ($env:PT_mysql_binlog_format) {
  $ExtraVars['mysql_binlog_format'] = $env:PT_mysql_binlog_format
}
if ($env:PT_mysql_key_buffer_size) {
  $ExtraVars['mysql_key_buffer_size'] = $env:PT_mysql_key_buffer_size
}
if ($env:PT_mysql_max_allowed_packet) {
  $ExtraVars['mysql_max_allowed_packet'] = $env:PT_mysql_max_allowed_packet
}
if ($env:PT_mysql_table_open_cache) {
  $ExtraVars['mysql_table_open_cache'] = $env:PT_mysql_table_open_cache
}
if ($env:PT_mysql_sort_buffer_size) {
  $ExtraVars['mysql_sort_buffer_size'] = $env:PT_mysql_sort_buffer_size
}
if ($env:PT_mysql_read_buffer_size) {
  $ExtraVars['mysql_read_buffer_size'] = $env:PT_mysql_read_buffer_size
}
if ($env:PT_mysql_read_rnd_buffer_size) {
  $ExtraVars['mysql_read_rnd_buffer_size'] = $env:PT_mysql_read_rnd_buffer_size
}
if ($env:PT_mysql_myisam_sort_buffer_size) {
  $ExtraVars['mysql_myisam_sort_buffer_size'] = $env:PT_mysql_myisam_sort_buffer_size
}
if ($env:PT_mysql_thread_cache_size) {
  $ExtraVars['mysql_thread_cache_size'] = $env:PT_mysql_thread_cache_size
}
if ($env:PT_mysql_query_cache_type) {
  $ExtraVars['mysql_query_cache_type'] = $env:PT_mysql_query_cache_type
}
if ($env:PT_mysql_query_cache_size) {
  $ExtraVars['mysql_query_cache_size'] = $env:PT_mysql_query_cache_size
}
if ($env:PT_mysql_query_cache_limit) {
  $ExtraVars['mysql_query_cache_limit'] = $env:PT_mysql_query_cache_limit
}
if ($env:PT_mysql_max_connections) {
  $ExtraVars['mysql_max_connections'] = $env:PT_mysql_max_connections
}
if ($env:PT_mysql_tmp_table_size) {
  $ExtraVars['mysql_tmp_table_size'] = $env:PT_mysql_tmp_table_size
}
if ($env:PT_mysql_max_heap_table_size) {
  $ExtraVars['mysql_max_heap_table_size'] = $env:PT_mysql_max_heap_table_size
}
if ($env:PT_mysql_group_concat_max_len) {
  $ExtraVars['mysql_group_concat_max_len'] = $env:PT_mysql_group_concat_max_len
}
if ($env:PT_mysql_join_buffer_size) {
  $ExtraVars['mysql_join_buffer_size'] = $env:PT_mysql_join_buffer_size
}
if ($env:PT_mysql_wait_timeout) {
  $ExtraVars['mysql_wait_timeout'] = $env:PT_mysql_wait_timeout
}
if ($env:PT_mysql_lower_case_table_names) {
  $ExtraVars['mysql_lower_case_table_names'] = $env:PT_mysql_lower_case_table_names
}
if ($env:PT_mysql_event_scheduler_state) {
  $ExtraVars['mysql_event_scheduler_state'] = $env:PT_mysql_event_scheduler_state
}
if ($env:PT_mysql_innodb_large_prefix) {
  $ExtraVars['mysql_innodb_large_prefix'] = $env:PT_mysql_innodb_large_prefix
}
if ($env:PT_mysql_innodb_file_format) {
  $ExtraVars['mysql_innodb_file_format'] = $env:PT_mysql_innodb_file_format
}
if ($env:PT_mysql_innodb_file_per_table) {
  $ExtraVars['mysql_innodb_file_per_table'] = $env:PT_mysql_innodb_file_per_table
}
if ($env:PT_mysql_innodb_buffer_pool_size) {
  $ExtraVars['mysql_innodb_buffer_pool_size'] = $env:PT_mysql_innodb_buffer_pool_size
}
if ($env:PT_mysql_innodb_log_file_size) {
  $ExtraVars['mysql_innodb_log_file_size'] = $env:PT_mysql_innodb_log_file_size
}
if ($env:PT_mysql_innodb_log_buffer_size) {
  $ExtraVars['mysql_innodb_log_buffer_size'] = $env:PT_mysql_innodb_log_buffer_size
}
if ($env:PT_mysql_innodb_flush_log_at_trx_commit) {
  $ExtraVars['mysql_innodb_flush_log_at_trx_commit'] = $env:PT_mysql_innodb_flush_log_at_trx_commit
}
if ($env:PT_mysql_innodb_lock_wait_timeout) {
  $ExtraVars['mysql_innodb_lock_wait_timeout'] = $env:PT_mysql_innodb_lock_wait_timeout
}
if ($env:PT_mysql_mysqldump_max_allowed_packet) {
  $ExtraVars['mysql_mysqldump_max_allowed_packet'] = $env:PT_mysql_mysqldump_max_allowed_packet
}
if ($env:PT_mysql_config_include_dir) {
  $ExtraVars['mysql_config_include_dir'] = $env:PT_mysql_config_include_dir
}
if ($env:PT_mysql_root_username) {
  $ExtraVars['mysql_root_username'] = $env:PT_mysql_root_username
}
if ($env:PT_mysql_root_password) {
  $ExtraVars['mysql_root_password'] = $env:PT_mysql_root_password
}
if ($env:PT_mysql_user_name) {
  $ExtraVars['mysql_user_name'] = $env:PT_mysql_user_name
}
if ($env:PT_mysql_user_password) {
  $ExtraVars['mysql_user_password'] = $env:PT_mysql_user_password
}
if ($env:PT_mysql_user_home) {
  $ExtraVars['mysql_user_home'] = $env:PT_mysql_user_home
}
if ($env:PT_mysql_root_home) {
  $ExtraVars['mysql_root_home'] = $env:PT_mysql_root_home
}
if ($env:PT_mysql_root_password_update) {
  $ExtraVars['mysql_root_password_update'] = $env:PT_mysql_root_password_update
}
if ($env:PT_mysql_user_password_update) {
  $ExtraVars['mysql_user_password_update'] = $env:PT_mysql_user_password_update
}
if ($env:PT_mysql_enabled_on_startup) {
  $ExtraVars['mysql_enabled_on_startup'] = $env:PT_mysql_enabled_on_startup
}
if ($env:PT_overwrite_global_mycnf) {
  $ExtraVars['overwrite_global_mycnf'] = $env:PT_overwrite_global_mycnf
}
if ($env:PT_mysql_copy_root_user_mycnf) {
  $ExtraVars['mysql_copy_root_user_mycnf'] = $env:PT_mysql_copy_root_user_mycnf
}
if ($env:PT_mysql_enablerepo) {
  $ExtraVars['mysql_enablerepo'] = $env:PT_mysql_enablerepo
}
if ($env:PT_mysql_python_package_debian) {
  $ExtraVars['mysql_python_package_debian'] = $env:PT_mysql_python_package_debian
}
if ($env:PT_mysql_skip_name_resolve) {
  $ExtraVars['mysql_skip_name_resolve'] = $env:PT_mysql_skip_name_resolve
}
if ($env:PT_mysql_log_file_group) {
  $ExtraVars['mysql_log_file_group'] = $env:PT_mysql_log_file_group
}
if ($env:PT_mysql_slow_query_log_enabled) {
  $ExtraVars['mysql_slow_query_log_enabled'] = $env:PT_mysql_slow_query_log_enabled
}
if ($env:PT_mysql_config_include_files) {
  $ExtraVars['mysql_config_include_files'] = $env:PT_mysql_config_include_files
}
if ($env:PT_mysql_databases) {
  $ExtraVars['mysql_databases'] = $env:PT_mysql_databases
}
if ($env:PT_mysql_users) {
  $ExtraVars['mysql_users'] = $env:PT_mysql_users
}
if ($env:PT_mysql_disable_log_bin) {
  $ExtraVars['mysql_disable_log_bin'] = $env:PT_mysql_disable_log_bin
}
if ($env:PT_mysql_replication_role) {
  $ExtraVars['mysql_replication_role'] = $env:PT_mysql_replication_role
}
if ($env:PT_mysql_replication_master) {
  $ExtraVars['mysql_replication_master'] = $env:PT_mysql_replication_master
}
if ($env:PT_mysql_replication_master_inventory_host) {
  $ExtraVars['mysql_replication_master_inventory_host'] = $env:PT_mysql_replication_master_inventory_host
}
if ($env:PT_mysql_replication_user) {
  $ExtraVars['mysql_replication_user'] = $env:PT_mysql_replication_user
}
if ($env:PT_mysql_hide_passwords) {
  $ExtraVars['mysql_hide_passwords'] = $env:PT_mysql_hide_passwords
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_mysql"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_mysql"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
