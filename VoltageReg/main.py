from EMF_regulation import EMF_voltage_regulation

P_rated = float(input("Power Rating Of the Sync Generator: "))
vol_rated = float(input("Voltage Rating of the Sync Generator: "))
Ra = float(input("Armature Resistatnce of single phase: "))
Vsc = float(input("Voltage At Short Circuit: "))
Isc = float(input("Current At Short Circuit: "))
pf = float(input("Power Factor Of sync Machine: "))

vol_reg = EMF_voltage_regulation(P_rated, vol_rated, Ra, Vsc, Isc, pf)

print (f"The Voltage Regulation is {vol_reg}")