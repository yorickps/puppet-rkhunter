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

      describe 'language' do
        context 'by default' do
          it do
            is_expected.to contain_file('/etc/rkhunter.conf').without_content(%r{^LANGUAGE})
          end
        end
        context 'when set' do
          let(:params) { { language: 'de' } }

          it do
            is_expected.to contain_file('/etc/rkhunter.conf').with_content(%r{^LANGUAGE=de$})
          end
        end
      end

      describe 'update_lang' do
        context 'by default' do
          it do
            is_expected.to contain_file('/etc/rkhunter.conf').without_content(%r{^UPDATE_LANG=})
          end
        end

        context 'when set' do
          let(:params) { { update_lang: %w[en de] } }

          it do
            is_expected.to contain_file('/etc/rkhunter.conf').with_content(%r{^UPDATE_LANG="en de"$})
          end
        end
      end
    end
  end
end
