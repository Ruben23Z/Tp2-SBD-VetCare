package model.Utilizador;

public class Rececionista extends Utilizador {

    public Rececionista() {
        super();
        setRececionista(true);
    }

    public Rececionista(int iDUtilizador) {
        super(iDUtilizador, false, true, false);
    }
}
