require 'spec_helper'

describe 'rpm_gpgkey' do
  context 'basic' do
    let(:title) { 'epel-6' }
    let(:params) {{ :keyid => '0608b895',
                    :path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6' }}

    it do should contain_exec('rpm-gpg-import-epel-6') \
        .with_command('/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6') \
        .with_unless('/bin/rpm --quiet -q gpg-pubkey-0608b895') \
        .with_onlyif('/usr/bin/test -f /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6')
    end
  end

  context 'implicit path' do
    let(:title) { 'epel-6' }
    let(:params) {{ :keyid => '0608b895',
                    :path => 'RPM-GPG-KEY-EPEL-6' }}

    it do should contain_exec('rpm-gpg-import-epel-6') \
        .with_command('/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6') \
        .with_onlyif('/usr/bin/test -f /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6')
    end
  end
end
