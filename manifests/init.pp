
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

  # quote keyid to explicitly stringify it, as hiera will return an
  # integer if the hexadecimal number includes only digits 0-9. downcase()
  # doesn't know what to do with an integer.
  $realkeyid = downcase("${keyid}")

  exec { "rpm-gpg-import-${name}":
    command => "/bin/rpm --import ${realpath}",
    unless  => "/bin/rpm --quiet -q gpg-pubkey-${realkeyid}",
    onlyif  => "/usr/bin/test -f ${realpath}",
  }
}
