package model.Utilizador;

public class Cliente extends Utilizador {
    private String NIF;
    private String nome;
    private String email;
    private String telefone;
    private String rua;
    private String pais;
    private String distrito;
    private String concelho;
    private String freguesia;

    public Cliente() {
    }

    public Cliente(int iDUtilizador, String NIF, String nome, String email, String telefone, String rua, String pais, String distrito, String concelho, String freguesia) {
        super(iDUtilizador, false, false, true, false);
        this.NIF = NIF;
        this.nome = nome;
        this.email = email;
        this.telefone = telefone;
        this.rua = rua;
        this.pais = pais;
        this.distrito = distrito;
        this.concelho = concelho;
        this.freguesia = freguesia;
    }

    public String getNIF() {
        return NIF;
    }

    public void setNIF(String NIF) {
        this.NIF = NIF;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getRua() {
        return rua;
    }

    public void setRua(String rua) {
        this.rua = rua;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public String getDistrito() {
        return distrito;
    }

    public void setDistrito(String distrito) {
        this.distrito = distrito;
    }

    public String getConcelho() {
        return concelho;
    }

    public void setConcelho(String concelho) {
        this.concelho = concelho;
    }

    public String getFreguesia() {
        return freguesia;
    }

    public void setFreguesia(String freguesia) {
        this.freguesia = freguesia;
    }

}
