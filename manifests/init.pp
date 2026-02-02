# paw_ansible_role_mysql
# @summary Manage paw_ansible_role_mysql configuration
#
# @param mysql_port MySQL connection settings.
# @param mysql_socket
# @param mysql_bind_address
# @param mysql_datadir
# @param mysql_pid_file
# @param mysql_sql_mode
# @param mysql_syslog_tag
# @param mysql_log Logging settings.
# @param mysql_log_error
# @param mysql_slow_query_log_file
# @param mysql_slow_query_time
# @param mysql_server_id Replication settings (replication is only enabled if master/user have values).
# @param mysql_expire_logs_days
# @param mysql_max_binlog_size
# @param mysql_binlog_format
# @param mysql_key_buffer_size Memory settings (default values optimized ~512MB RAM).
# @param mysql_max_allowed_packet
# @param mysql_table_open_cache
# @param mysql_sort_buffer_size
# @param mysql_read_buffer_size
# @param mysql_read_rnd_buffer_size
# @param mysql_myisam_sort_buffer_size
# @param mysql_thread_cache_size
# @param mysql_query_cache_type their previous MySQL counterparts
# @param mysql_query_cache_size
# @param mysql_query_cache_limit
# @param mysql_max_connections
# @param mysql_tmp_table_size
# @param mysql_max_heap_table_size
# @param mysql_group_concat_max_len
# @param mysql_join_buffer_size
# @param mysql_wait_timeout
# @param mysql_lower_case_table_names Other settings.
# @param mysql_event_scheduler_state
# @param mysql_innodb_large_prefix These settings require MySQL > 5.5.
# @param mysql_innodb_file_format
# @param mysql_innodb_file_per_table InnoDB settings.
# @param mysql_innodb_buffer_pool_size Set .._buffer_pool_size up to 80% of RAM but beware of setting too high.
# @param mysql_innodb_log_file_size Set .._log_file_size to 25% of buffer pool size.
# @param mysql_innodb_log_buffer_size
# @param mysql_innodb_flush_log_at_trx_commit
# @param mysql_innodb_lock_wait_timeout
# @param mysql_mysqldump_max_allowed_packet mysqldump settings.
# @param mysql_config_include_dir
# @param mysql_root_username
# @param mysql_root_password
# @param mysql_user_name
# @param mysql_user_password
# @param mysql_user_home or sudo access
# @param mysql_root_home The default root user installed by mysql - almost always root
# @param mysql_root_password_update Set this to `true` to forcibly update the root password.
# @param mysql_user_password_update
# @param mysql_enabled_on_startup
# @param overwrite_global_mycnf Whether my.cnf should be updated on every run.
# @param mysql_copy_root_user_mycnf Whether to copy root user's config file with credentials to their homedir
# @param mysql_enablerepo for RedHat systems (and derivatives).
# @param mysql_python_package_debian
# @param mysql_skip_name_resolve
# @param mysql_log_file_group Log file settings.
# @param mysql_slow_query_log_enabled Slow query log settings.
# @param mysql_config_include_files
# @param mysql_databases Databases.
# @param mysql_users Users.
# @param mysql_disable_log_bin
# @param mysql_replication_role
# @param mysql_replication_master
# @param mysql_replication_master_inventory_host
# @param mysql_replication_user Same keys as `mysql_users` above.
# @param mysql_hide_passwords
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_mysql (
  String $mysql_port = '3306',
  Optional[String] $mysql_socket = undef,
  String $mysql_bind_address = '0.0.0.0',
  String $mysql_datadir = '/var/lib/mysql',
  Optional[String] $mysql_pid_file = undef,
  Optional[String] $mysql_sql_mode = undef,
  Optional[String] $mysql_syslog_tag = undef,
  Optional[String] $mysql_log = undef,
  Optional[String] $mysql_log_error = undef,
  Optional[String] $mysql_slow_query_log_file = undef,
  String $mysql_slow_query_time = '2',
  String $mysql_server_id = '1',
  String $mysql_expire_logs_days = '10',
  String $mysql_max_binlog_size = '100M',
  String $mysql_binlog_format = 'ROW',
  String $mysql_key_buffer_size = '256M',
  String $mysql_max_allowed_packet = '64M',
  String $mysql_table_open_cache = '256',
  String $mysql_sort_buffer_size = '1M',
  String $mysql_read_buffer_size = '1M',
  String $mysql_read_rnd_buffer_size = '4M',
  String $mysql_myisam_sort_buffer_size = '64M',
  String $mysql_thread_cache_size = '8',
  String $mysql_query_cache_type = '0',
  String $mysql_query_cache_size = '16M',
  String $mysql_query_cache_limit = '1M',
  String $mysql_max_connections = '151',
  String $mysql_tmp_table_size = '16M',
  String $mysql_max_heap_table_size = '16M',
  String $mysql_group_concat_max_len = '1024',
  String $mysql_join_buffer_size = '262144',
  String $mysql_wait_timeout = '28800',
  String $mysql_lower_case_table_names = '0',
  String $mysql_event_scheduler_state = 'OFF',
  String $mysql_innodb_large_prefix = '1',
  String $mysql_innodb_file_format = 'barracuda',
  String $mysql_innodb_file_per_table = '1',
  String $mysql_innodb_buffer_pool_size = '256M',
  String $mysql_innodb_log_file_size = '64M',
  String $mysql_innodb_log_buffer_size = '8M',
  String $mysql_innodb_flush_log_at_trx_commit = '1',
  String $mysql_innodb_lock_wait_timeout = '50',
  String $mysql_mysqldump_max_allowed_packet = '64M',
  Optional[String] $mysql_config_include_dir = undef,
  String $mysql_root_username = 'root',
  String $mysql_root_password = 'root',
  String $mysql_user_name = 'root',
  String $mysql_user_password = 'root',
  String $mysql_user_home = '/root',
  String $mysql_root_home = '/root',
  Boolean $mysql_root_password_update = false,
  Boolean $mysql_user_password_update = false,
  Boolean $mysql_enabled_on_startup = true,
  Boolean $overwrite_global_mycnf = true,
  Boolean $mysql_copy_root_user_mycnf = true,
  Optional[String] $mysql_enablerepo = undef,
  String $mysql_python_package_debian = 'python3-mysqldb',
  Boolean $mysql_skip_name_resolve = false,
  String $mysql_log_file_group = 'mysql',
  Boolean $mysql_slow_query_log_enabled = false,
  Array $mysql_config_include_files = [],
  Array $mysql_databases = [],
  Array $mysql_users = [],
  Boolean $mysql_disable_log_bin = false,
  Optional[String] $mysql_replication_role = undef,
  Optional[String] $mysql_replication_master = undef,
  String $mysql_replication_master_inventory_host = '{{ mysql_replication_master }}',
  Array $mysql_replication_user = [],
  Boolean $mysql_hide_passwords = false,
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
  $_par_vardir = $par_vardir ? {
    undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
    default => $par_vardir,
  }
  $playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_mysql/playbook.yml"

  par { 'paw_ansible_role_mysql-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'mysql_port'                              => $mysql_port,
      'mysql_socket'                            => $mysql_socket,
      'mysql_bind_address'                      => $mysql_bind_address,
      'mysql_datadir'                           => $mysql_datadir,
      'mysql_pid_file'                          => $mysql_pid_file,
      'mysql_sql_mode'                          => $mysql_sql_mode,
      'mysql_syslog_tag'                        => $mysql_syslog_tag,
      'mysql_log'                               => $mysql_log,
      'mysql_log_error'                         => $mysql_log_error,
      'mysql_slow_query_log_file'               => $mysql_slow_query_log_file,
      'mysql_slow_query_time'                   => $mysql_slow_query_time,
      'mysql_server_id'                         => $mysql_server_id,
      'mysql_expire_logs_days'                  => $mysql_expire_logs_days,
      'mysql_max_binlog_size'                   => $mysql_max_binlog_size,
      'mysql_binlog_format'                     => $mysql_binlog_format,
      'mysql_key_buffer_size'                   => $mysql_key_buffer_size,
      'mysql_max_allowed_packet'                => $mysql_max_allowed_packet,
      'mysql_table_open_cache'                  => $mysql_table_open_cache,
      'mysql_sort_buffer_size'                  => $mysql_sort_buffer_size,
      'mysql_read_buffer_size'                  => $mysql_read_buffer_size,
      'mysql_read_rnd_buffer_size'              => $mysql_read_rnd_buffer_size,
      'mysql_myisam_sort_buffer_size'           => $mysql_myisam_sort_buffer_size,
      'mysql_thread_cache_size'                 => $mysql_thread_cache_size,
      'mysql_query_cache_type'                  => $mysql_query_cache_type,
      'mysql_query_cache_size'                  => $mysql_query_cache_size,
      'mysql_query_cache_limit'                 => $mysql_query_cache_limit,
      'mysql_max_connections'                   => $mysql_max_connections,
      'mysql_tmp_table_size'                    => $mysql_tmp_table_size,
      'mysql_max_heap_table_size'               => $mysql_max_heap_table_size,
      'mysql_group_concat_max_len'              => $mysql_group_concat_max_len,
      'mysql_join_buffer_size'                  => $mysql_join_buffer_size,
      'mysql_wait_timeout'                      => $mysql_wait_timeout,
      'mysql_lower_case_table_names'            => $mysql_lower_case_table_names,
      'mysql_event_scheduler_state'             => $mysql_event_scheduler_state,
      'mysql_innodb_large_prefix'               => $mysql_innodb_large_prefix,
      'mysql_innodb_file_format'                => $mysql_innodb_file_format,
      'mysql_innodb_file_per_table'             => $mysql_innodb_file_per_table,
      'mysql_innodb_buffer_pool_size'           => $mysql_innodb_buffer_pool_size,
      'mysql_innodb_log_file_size'              => $mysql_innodb_log_file_size,
      'mysql_innodb_log_buffer_size'            => $mysql_innodb_log_buffer_size,
      'mysql_innodb_flush_log_at_trx_commit'    => $mysql_innodb_flush_log_at_trx_commit,
      'mysql_innodb_lock_wait_timeout'          => $mysql_innodb_lock_wait_timeout,
      'mysql_mysqldump_max_allowed_packet'      => $mysql_mysqldump_max_allowed_packet,
      'mysql_config_include_dir'                => $mysql_config_include_dir,
      'mysql_root_username'                     => $mysql_root_username,
      'mysql_root_password'                     => $mysql_root_password,
      'mysql_user_name'                         => $mysql_user_name,
      'mysql_user_password'                     => $mysql_user_password,
      'mysql_user_home'                         => $mysql_user_home,
      'mysql_root_home'                         => $mysql_root_home,
      'mysql_root_password_update'              => $mysql_root_password_update,
      'mysql_user_password_update'              => $mysql_user_password_update,
      'mysql_enabled_on_startup'                => $mysql_enabled_on_startup,
      'overwrite_global_mycnf'                  => $overwrite_global_mycnf,
      'mysql_copy_root_user_mycnf'              => $mysql_copy_root_user_mycnf,
      'mysql_enablerepo'                        => $mysql_enablerepo,
      'mysql_python_package_debian'             => $mysql_python_package_debian,
      'mysql_skip_name_resolve'                 => $mysql_skip_name_resolve,
      'mysql_log_file_group'                    => $mysql_log_file_group,
      'mysql_slow_query_log_enabled'            => $mysql_slow_query_log_enabled,
      'mysql_config_include_files'              => $mysql_config_include_files,
      'mysql_databases'                         => $mysql_databases,
      'mysql_users'                             => $mysql_users,
      'mysql_disable_log_bin'                   => $mysql_disable_log_bin,
      'mysql_replication_role'                  => $mysql_replication_role,
      'mysql_replication_master'                => $mysql_replication_master,
      'mysql_replication_master_inventory_host' => $mysql_replication_master_inventory_host,
      'mysql_replication_user'                  => $mysql_replication_user,
      'mysql_hide_passwords'                    => $mysql_hide_passwords,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}
