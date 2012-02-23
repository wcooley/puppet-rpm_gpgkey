
define rpm_gpgkey($path, $keyid) {
    exec { "rpm-gpg-import-$name":
        command => "/bin/rpm --import $path",
        unless  => "/bin/rpm --quiet -q gpg-pubkey-$keyid",
        onlyif  => "test -f $path",
    }
}
