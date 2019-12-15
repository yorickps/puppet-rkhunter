require 'spec_helper'

describe 'rkhunter', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_class('rkhunter::packages') }
      it { is_expected.to contain_class('rkhunter::params') }
      it do
        is_expected.to contain_file('/etc/rkhunter.conf').with(
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644'
        )
      end
      it { is_expected.to contain_file('/usr/local/bin/rktask') }
      it { is_expected.to contain_file('/var/lib/rkhunter/db/mirrors.dat') }
      it { is_expected.to contain_package('rkhunter').with('ensure' => 'installed') }
      it { is_expected.to contain_exec('/usr/bin/rkhunter --propupd') }
      it { is_expected.to contain_file_line('Remove local mirror from mirrors.dat') }
    end
  end
end
