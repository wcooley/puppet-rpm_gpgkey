
define rpm_gpgkey($path, $keyid) {

    $rpm_gpg_dir = '/etc/pki/rpm-gpg'

    # Ensure that the key file exists if it is a local file before attempting
    # to import it
    if $path !~ /^(https?|ftp):/ {

        # Permit the path to be a puppet:// URL by making a $realpath based on
        # the final element of the URL and the local rpm gpg directory
        if $path =~ /^puppet:/ {
            $path_array = split($path, '/')
            $realpath = "${rpm_gpg_dir}/${path_array[-1]}"

            file { $realpath:
                ensure => 'present',
                source => $path,
            }
        }
        else {
            $realpath = $path
            file { $realpath:
                ensure => 'present',
            }
        }

        # Require the file in order to run the import
        File[$realpath] -> Exec["rpm-gpg-import-$name"]
    }
    else {
        $realpath = $path
    }

    exec { "rpm-gpg-import-$name":
        command => "/bin/rpm --import $realpath",
        unless  => "/bin/rpm --quiet -q gpg-pubkey-$keyid",
    }
}
