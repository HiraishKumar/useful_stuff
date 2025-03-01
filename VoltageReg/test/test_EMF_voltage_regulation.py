import unittest
import pdb
from EMF_regulation import EMF_voltage_regulation

class Test_EMF_Vol_Reg(unittest.TestCase):
    def test_voltage_regulation(self):
    # Test input values
        P_rated = 1200000
        vol_rated = 3300
        Ra = 0.25
        Vsc = 1100
        Isc = 200
        pf = 0.8
         
        # pdb.set_trace()
        # Expected output
        expected_output = 25.911
        # Function call and assertion
        result = EMF_voltage_regulation(P_rated, vol_rated, Ra, Vsc, Isc, pf)
        self.assertAlmostEqual(result, expected_output, places=1)

    def test_voltage_regulation_high_power_factor(self):
        """Test with a high power factor (e.g., 0.95)"""
        P_rated = 1500000
        vol_rated = 11000
        Ra = 0.15
        Vsc = 1200
        Isc = 250
        pf = 0.95

        expected_output = 1.298  # Replace with actual expected value
        result = EMF_voltage_regulation(P_rated, vol_rated, Ra, Vsc, Isc, pf)
        self.assertAlmostEqual(result, expected_output, places=1)

    def test_voltage_regulation_negative_power_factor(self):
        """Test with a negative power factor (leading power factor)"""
        P_rated = 500000
        vol_rated = 600
        Ra = 0.25
        Vsc = 800
        Isc = 120
        pf = -0.7  # Leading power factor

        expected_output = 363.400  # Replace with actual expected value
        result = EMF_voltage_regulation(P_rated, vol_rated, Ra, Vsc, Isc, pf)
        self.assertAlmostEqual(result, expected_output, places=1)

if __name__ == "__main__":
    unittest.main()

    