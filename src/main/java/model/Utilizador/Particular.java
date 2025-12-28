package model.Utilizador;

public class Particular extends Cliente {
    private String prefLinguistica;

    public Particular() { super(); }

    public Particular(int iDUtilizador, String NIF, String nome, String email, String telefone,
                      String rua, String pais, String distrito, String concelho, String freguesia,
                      String prefLinguistica) {
        super(iDUtilizador, NIF, nome, email, telefone, rua, pais, distrito, concelho, freguesia);
        this.prefLinguistica = prefLinguistica;
    }

    public String getPrefLinguistica() { return prefLinguistica; }
    public void setPrefLinguistica(String prefLinguistica) { this.prefLinguistica = prefLinguistica; }
}
