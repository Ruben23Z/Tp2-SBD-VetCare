package model.Utilizador;

public class Utilizador {
    private int iDUtilizador;
    private boolean isVeterinario;
    private boolean isRececionista;
    private boolean isCliente;
    private boolean isGerente;

    private String username;
    private String password;

    public Utilizador() {
    }

    //    Constructor sem Rececionista user nem pass
    public Utilizador(boolean isVeterinario, boolean isRececionista, boolean isCliente, boolean isGerente, String username, String password) {
        this.isVeterinario = isVeterinario;
        this.isRececionista = isRececionista;
        this.isCliente = isCliente;
        this.isGerente = isGerente;
        this.username = username;
        this.password = password;
    }

    // Construtor COM ID (quando vem da BD)
    public Utilizador(int iDUtilizador, boolean isVeterinario, boolean isRececionista, boolean isCliente, boolean isGerente) {
        this.iDUtilizador = iDUtilizador;
        this.isVeterinario = isVeterinario;
        this.isRececionista = isRececionista;
        this.isCliente = isCliente;
        this.isGerente = isGerente;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getiDUtilizador() {
        return iDUtilizador;
    }

    public void setiDUtilizador(int iDUtilizador) {
        this.iDUtilizador = iDUtilizador;
    }

    public boolean isVeterinario() {
        return isVeterinario;
    }

    public void setVeterinario(boolean veterinario) {
        isVeterinario = veterinario;
    }

    public boolean isRececionista() {
        return isRececionista;
    }

    public void setRececionista(boolean rececionista) {
        isRececionista = rececionista;
    }

    public boolean isCliente() {
        return isCliente;
    }

    public void setCliente(boolean cliente) {
        isCliente = cliente;
    }

    public boolean isGerente() {
        return isGerente;
    }

    public void setGerente(boolean gerente) {
        isGerente = gerente;
    }

}
