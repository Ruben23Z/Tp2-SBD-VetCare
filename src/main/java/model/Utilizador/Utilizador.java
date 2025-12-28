package model.Utilizador;

public class Utilizador {
    private int iDUtilizador;
    private boolean isVeterinario;
    private boolean isRececionista;
    private boolean isCliente;

    public Utilizador() {}

    public Utilizador(int iDUtilizador, boolean isVeterinario, boolean isRececionista, boolean isCliente) {
        this.iDUtilizador = iDUtilizador;
        this.isVeterinario = isVeterinario;
        this.isRececionista = isRececionista;
        this.isCliente = isCliente;
    }

    public int getiDUtilizador() { return iDUtilizador; }
    public void setiDUtilizador(int iDUtilizador) { this.iDUtilizador = iDUtilizador; }

    public boolean isVeterinario() { return isVeterinario; }
    public void setVeterinario(boolean veterinario) { isVeterinario = veterinario; }

    public boolean isRececionista() { return isRececionista; }
    public void setRececionista(boolean rececionista) { isRececionista = rececionista; }

    public boolean isCliente() { return isCliente; }
    public void setCliente(boolean cliente) { isCliente = cliente; }
}
