require 'spec_helper'

describe 'rkhunter::packages', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it do
        is_expected.to contain_package('rkhunter').with(
          'ensure' => 'installed'
        )
      end
    end
  end
end
