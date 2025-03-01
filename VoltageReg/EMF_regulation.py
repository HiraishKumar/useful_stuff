def EMF_voltage_regulation(P_rated, vol_rated, Ra, Vsc, Isc, pf):
    Vph = vol_rated / 1.732
    Iph = P_rated / (1.732 * vol_rated)
    Zs = Vsc / (Isc * 1.732)
    Xs = (Zs**2 - Ra**2)**0.5

    pf_sin = (1-pf**2)**0.5

    if pf >= 0:
        E = ((Vph * pf + Iph * Ra) ** 2 + (Vph * pf_sin + Iph * Xs) ** 2) ** 0.5
    else:
        E = ((Vph * pf + Iph * Ra) ** 2 + (Vph * pf_sin - Iph * Xs) ** 2) ** 0.5

    vol_reg = ((E - Vph) * 100) / Vph
    return vol_reg