$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'minitest/autorun'
require 'rubystats/normal_distribution'

class TestNormal < MiniTest::Unit::TestCase
  def test_cdf

    norm = Rubystats::NormalDistribution.new(10,2)
    cdf = norm.cdf(11)

    assert_equal('0.691462461274013', '%.15f' % cdf)
    refute_nil(norm.rng)
  end

  def test_distribution
    norm = Rubystats::NormalDistribution.new(10.0, 1.0)
    assert_instance_of Float, norm.rng

    total = 10000
    values =Array.new(total).map{norm.rng.to_i}
    histogram = Hash[*values.group_by{ |v| v }.flat_map{ |k, v| [k, v.size] }]

    one_sigma = histogram[9] + histogram[10]
    assert_in_epsilon 0.682689492137 , one_sigma.to_f / total, 0.02, 'the 1-sigma-environment should contain 68.3%'

    two_sigma = one_sigma + histogram[8] + histogram[11]
    assert_in_epsilon 0.954499736104 , two_sigma.to_f / total, 0.004, 'the 2-sigma-environment should contain 95.4%'

    three_sigma = two_sigma + histogram[7] + histogram[12]
    assert_in_epsilon 0.997300203937 , three_sigma.to_f / total, 0.001, 'the 3-sigma-environment should contain 99.7%'

  end
end
