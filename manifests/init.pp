#
# == Define: rpm_gpgkey
#
# Defined type to install RPM GPG keys.
#
# Yum can automatically import keys given the URL, but the RHN or Spacewalk
# client cannot (or will not). Even for *yum*, it might be preferable to
# explicitly manage keys.
#
# === Parameters
#
# [*namevar*]
#   Short mnemonic for the key name. Only used as in the title of the `exec`
#   resource.
#
# [*path*]
#   Path to key file (or just file name, if in /etc/pkg/rpm-gpg).
#
# [*keyid*]
#   Key ID as string.
#
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
