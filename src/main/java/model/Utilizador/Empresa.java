package model.Utilizador;

import java.math.BigDecimal;

public class Empresa extends Cliente {
    private BigDecimal capitalSocial;

    public Empresa() { super(); }

    public Empresa(int iDUtilizador, String NIF, String nome, String email, String telefone,
                   String rua, String pais, String distrito, String concelho, String freguesia,
                   BigDecimal capitalSocial) {
        super(iDUtilizador, NIF, nome, email, telefone, rua, pais, distrito, concelho, freguesia);
        this.capitalSocial = capitalSocial;
    }

    public BigDecimal getCapitalSocial() { return capitalSocial; }
    public void setCapitalSocial(BigDecimal capitalSocial) { this.capitalSocial = capitalSocial; }
}
