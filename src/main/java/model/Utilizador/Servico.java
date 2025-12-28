package model.Utilizador;

public class Servico {

    protected int idServico;
    protected String descricao;

    public Servico(int idServico, String descricao) {
        this.idServico = idServico;
        this.descricao = descricao;
    }

    public int getIdServico() {
        return idServico;
    }

    public String getDescricao() {
        return descricao;
    }
}
