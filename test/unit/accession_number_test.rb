require 'test_helper'

class AccessionNumberTest < ActiveSupport::TestCase
  test 'instances have the right string representation' do
    an = AccessionNumber.new('abc123')
    assert_equal 'abc123', an.to_s
  end

  test 'instance is immutable' do
    an = AccessionNumber.new('abc123')
    assert_raises(RuntimeError){an.send(:initialize, 'def456')}
  end

  test 'has the right sense of equality' do
    an1 = AccessionNumber.new('abc123')
    an2 = AccessionNumber.new('abc123')
    an3 = AccessionNumber.new('def456')

    assert an1 == an1
    assert an1 == an2 # equal if their values are equal
    assert !(an1 == an3)
    assert an1 != an3
  end
end