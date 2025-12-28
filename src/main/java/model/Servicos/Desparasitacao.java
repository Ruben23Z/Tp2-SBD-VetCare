package model.Servicos;

import model.ServicoMedicoAgendamento;

// DESPARASITAÇÃO
public class Desparasitacao extends ServicoMedicoAgendamento {
    private String dose;
    private String produtos;
    private Boolean interna;

    public Desparasitacao(int idServico, String descricao) {
        super(idServico, descricao);
    }

    // getters e setters
    public String getDose() { return dose; }
    public void setDose(String dose) { this.dose = dose; }

    public String getProdutos() { return produtos; }
    public void setProdutos(String produtos) { this.produtos = produtos; }

    public Boolean getInterna() { return interna; }
    public void setInterna(Boolean interna) { this.interna = interna; }
}
