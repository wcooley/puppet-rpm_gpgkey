
define rpm_gpgkey($path, $keyid) {
  if $path =~ /^(f|ht)tps?:/ {
    fail('rpm_gpgkey does not work with remote paths!')
  }

  if $path !~ /^\// {
    $realpath = "/etc/pki/rpm-gpg/${path}"
  }
  else {
    $realpath = $path
  }

  if is_string($keyid) {
    $realkeyid = downcase($keyid)
  }
  else {
    $realkeyid = $keyid
  }

  exec { "rpm-gpg-import-${name}":
    command => "/bin/rpm --import ${realpath}",
    unless  => "/bin/rpm --quiet -q gpg-pubkey-${realkeyid}",
    onlyif  => "/usr/bin/test -f ${realpath}",
  }
}
