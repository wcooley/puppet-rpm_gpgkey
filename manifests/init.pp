
define rpm_gpgkey($path, $keyid) {
  if $path =~ /^(f|ht)tps?:/ {
    fail('rpm_gpgkey does not work with remote paths!')
  }

  exec { "rpm-gpg-import-$name":
    command => "/bin/rpm --import $path",
    unless  => "/bin/rpm --quiet -q gpg-pubkey-$keyid",
    onlyif  => "/usr/bin/test -f $path",
  }
}
