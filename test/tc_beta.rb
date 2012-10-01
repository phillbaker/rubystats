$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'rubystats/beta_distribution'

class TestBeta < Test::Unit::TestCase
	def test_simple
		p = 12
		q = 59
		beta = Rubystats::BetaDistribution.new(p,q)
		assert_equal("0.169014084507042", beta.mean.to_s)
		assert_equal("0.0441664031038187", beta.standard_deviation.to_s)
		assert_equal("6.26075815849967", beta.pdf(0.2).to_s)
		assert_equal("0.999999997766913", beta.cdf(0.50).to_s)
		assert_equal("0.102003194113565", beta.icdf(0.05).to_s)

		x_vals = [0.1, 0.15, 0.2, 0.25, 0.3, 0.35]
		p_vals = beta.pdf(x_vals)
		c_vals = beta.cdf(x_vals)
		expected_pvals = [ 2.83232625227534,
			8.89978000366836,
			6.26075815849967,
			1.72572305993386,
			0.234475706454223,
			0.0173700433944934]
		expected_cvals = [0.0440640755091473,
			0.356009606171447,
			0.768319101921981,
			0.956058132801147,
			0.995358286711105,
			0.99971672771575]
     
    0.upto(x_vals.size - 1) do |i|
      assert_in_delta expected_pvals[i], p_vals[i], 0.00000001
      assert_in_delta expected_cvals[i], c_vals[i], 0.00000001
      i += 1
    end

		x_vals.each do |x|
			cdf = beta.cdf(x)
			inv_cdf = beta.icdf(cdf)
			assert_in_delta(x, inv_cdf, 0.00000001)
		end
	end

  def test_low_p_and_q_values
		p = 1.5 
		q = 1.0 
		beta = Rubystats::BetaDistribution.new(p,q)

    #from PHPExcel/PHPMath output
    expected_icdf_vals = [
    0.096548938, 0.153261886, 0.200829885, 0.243288080, 0.282310809, 0.318797571, 0.353302082, 0.386195754, 0.417742995, 0.448140475, 0.477539492, 0.506059599, 0.533797339, 0.560832096, 0.587230146, 0.613047546, 0.638332246, 0.663125670, 0.687463910, 0.711378661, 0.734897945, 0.758046692, 0.780847206, 0.803319540, 0.825481812, 0.847350458, 0.868940446, 0.890265460, 0.911338047, 0.932169752, 0.952771225, 0.973152319, 0.993322173]
    expected_cdf_vals = [
    0.005196152, 0.014696938, 0.027000000, 0.041569219, 0.058094750, 0.076367532, 0.096234090, 0.117575508, 0.140296115, 0.164316767, 0.189570567, 0.216000000, 0.243554922, 0.272191109, 0.301869177, 0.332553755, 0.364212850, 0.396817338, 0.430340563, 0.464758002, 0.500046998, 0.536186535, 0.573157047, 0.610940259, 0.649519053, 0.688877348, 0.729000000, 0.769872717, 0.811481978, 0.853814968, 0.896859521, 0.940604061, 0.985037563 ]
    i = 0
    0.03.step(1.0, 0.03) do |x|
      assert_in_delta expected_icdf_vals[i], beta.icdf(x), 0.00000001
      assert_in_delta expected_cdf_vals[i], beta.cdf(x), 0.00000001
      i += 1
    end
  end

	def test_control_limits
		trials = 50
		alpha = 0.05
		p = 10
		lcl = get_lower_limit(trials, alpha, p)
		ucl = get_upper_limit(trials, alpha, p)
		assert_equal("0.112721613414076",lcl.to_s)
		assert_equal("0.315596061420013",ucl.to_s)

		trials = 210 
		alpha = 0.10
		p = 47 
		lcl = get_lower_limit(trials, alpha, p)
		ucl = get_upper_limit(trials, alpha, p)
		assert_equal("0.186679485269901",lcl.to_s)
		assert_equal("0.264957601783544",ucl.to_s)
	end

	def get_lower_limit(trials,alpha,p)
		if p==0
			lcl=0
		else
			q=trials-p+1
			bin= Rubystats::BetaDistribution.new(p,q)
			lcl=bin.icdf(alpha)
		end
		return lcl
	end

	def get_upper_limit(trials,alpha,p)
		q=trials-p
		p=p+1
		bin= Rubystats::BetaDistribution.new(p,q)
		ucl=bin.icdf(1-alpha)
		return ucl
	end

end
