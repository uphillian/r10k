# == Class: r10k::webhook::config
#
# Set up the root r10k config file (/etc/webhook.yaml).
#
# === Authors
#
# Zack Smith <zack@puppetlabs.com>
class r10k::webhook::config (
  $hash                  = 'UNSET',
  $certname              = $r10k::params::webhook_certname,
  $certpath              = $r10k::params::webhook_certpath,
  $user                  = $r10k::params::webhook_user,
  $pass                  = $r10k::params::webhook_pass,
  $bind_address          = $r10k::params::webhook_bind_address,
  $port                  = $r10k::params::webhook_port,
  $access_logfile        = $r10k::params::webhook_access_logfile,
  $client_cfg            = $r10k::params::webhook_client_cfg,
  $use_mco_ruby          = $r10k::params::webhook_use_mco_ruby,
  $protected             = $r10k::params::webhook_protected,
  $discovery_timeout     = $r10k::params::webhook_discovery_timeout,
  $client_timeout        = $r10k::params::webhook_client_timeout,
  $prefix                = $r10k::params::webhook_prefix,
  $prefix_command        = $r10k::params::webhook_prefix_command,
  $server_software        = $r10k::params::webhook_server_software,
  $enable_ssl            = $r10k::params::webhook_enable_ssl,
  $use_mcollective       = $r10k::params::webhook_use_mcollective,
  $r10k_deploy_arguments = $r10k::params::webhook_r10k_deploy_arguments,
  $public_key_path       = $r10k::params::webhook_public_key_path,
  $private_key_path      = $r10k::params::webhook_private_key_path,
  $yaml_template         = $r10k::params::webhook_yaml_template,
  $command_prefix        = $r10k::params::webhook_r10k_command_prefix,
  $repository_events     = $r10k::params::webhook_repository_events,
  $configfile            = '/etc/webhook.yaml',
  $manage_symlink        = false,
  $configfile_symlink    = '/etc/webhook.yaml',
  $enable_mutex_lock     = $r10k::params::webhook_enable_mutex_lock,
) inherits r10k::params {

  if $hash == 'UNSET' {
    $webhook_hash  = {
      'user'                  => $user,
      'pass'                  => $pass,
      'bind_address'          => $bind_address,
      'port'                  => $port,
      'certname'              => $certname,
      'client_timeout'        => $client_timeout,
      'discovery_timeout'     => $discovery_timeout,
      'certpath'              => $certpath,
      'client_cfg'            => $client_cfg,
      'certpath'              => $certpath,
      'use_mco_ruby'          => $use_mco_ruby,
      'access_logfile'        => $access_logfile,
      'protected'             => $protected,
      'prefix'                => $prefix,
      'prefix_command'        => $prefix_command,
      'server_software'       => $server_software,
      'enable_ssl'            => $enable_ssl,
      'use_mcollective'       => $use_mcollective,
      'r10k_deploy_arguments' => $r10k_deploy_arguments,
      'public_key_path'       => $public_key_path,
      'private_key_path'      => $private_key_path,
      'command_prefix'        => $command_prefix,
      'repository_events'     => $repository_events,
      'enable_mutex_lock'     => $enable_mutex_lock,
    }
  } else {
    validate_hash($hash)
    $webhook_hash = $hash
  }

  file { 'webhook.yaml':
    ensure  => file,
    owner   => 'root',
    group   => '0',
    mode    => '0644',
    path    => $configfile,
    content => template($yaml_template),
    notify  => Service['webhook'],
  }

  if $manage_symlink {
    file { 'symlink_webhook.yaml':
      ensure => 'link',
      path   => $configfile_symlink,
      target => $configfile,
    }
  }
}
