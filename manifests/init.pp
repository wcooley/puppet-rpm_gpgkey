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

  if $path =~ /^(f|ht)tps?:/ {
    exec { "rpm-gpg-import-${name}":
      command => "/bin/rpm --import ${realpath}",
      unless  => "/bin/rpm --quiet -q gpg-pubkey-${realkeyid}",
    }
  } else {
    exec { "rpm-gpg-import-${name}":
      command => "/bin/rpm --import ${realpath}",
      unless  => "/bin/rpm --quiet -q gpg-pubkey-${realkeyid}",
      onlyif  => "/usr/bin/test -f ${realpath}",
    }
  }
}
#
#   Copyright 2014 Wil Cooley
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
