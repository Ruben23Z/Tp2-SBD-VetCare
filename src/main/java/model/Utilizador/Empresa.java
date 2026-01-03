package model.Utilizador;

public class Empresa {


    private String nif;
    private int capitalSocial;

    public Empresa(String nif, int capitalSocial) {
        this.nif = nif;
        this.capitalSocial = capitalSocial;
    }

    public String getNif() {
        return nif;
    }

    public void setNif(String nif) {
        this.nif = nif;
    }

    public int getCapitalSocial() {
        return capitalSocial;
    }

    public void setCapitalSocial(int capitalSocial) {
        this.capitalSocial = capitalSocial;
    }

}
