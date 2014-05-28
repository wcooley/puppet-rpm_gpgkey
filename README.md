rpm\_gpgkey
===========

Purpose
-------

This provides the defined type `rpm_gpgkey`, for installing GPG keys for RPM.

Unlike Yum, RHN/Spacewalk client does not automatically import GPG keys, so it
is necessary to do so outside of RHN client.

Note that it does not currently manage the RPM GPG key file itself.

Example
-------

    $epel6key = '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6'

    rpm_gpgkey { 'epel-6':
      keyid => '0608b895',
      path => $epel6key,
    }

    file { $epel6key:
      source => 'puppet:///xxx/RPM-GPG-KEY-EPEL-6',
    }

    File[$epel6key] -> Rpm_gpgkey['epel-6']

License
-------

See LICENSE.
