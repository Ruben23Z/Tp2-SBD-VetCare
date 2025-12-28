package model.Servicos;

import model.ServicoMedicoAgendamento;

import java.time.LocalDate;

// VACINAÇÃO
public class Vacinacao extends ServicoMedicoAgendamento {
    private String fabricante;
    private String dose;
    private String viaAdministracao;
    private LocalDate dataValidade;
    private LocalDate dataReforco;

    public Vacinacao(int idServico, String descricao) {
        super(idServico, descricao);
    }

    // getters e setters
    public String getFabricante() { return fabricante; }
    public void setFabricante(String fabricante) { this.fabricante = fabricante; }

    public String getDose() { return dose; }
    public void setDose(String dose) { this.dose = dose; }

    public String getViaAdministracao() { return viaAdministracao; }
    public void setViaAdministracao(String viaAdministracao) { this.viaAdministracao = viaAdministracao; }

    public LocalDate getDataValidade() { return dataValidade; }
    public void setDataValidade(LocalDate dataValidade) { this.dataValidade = dataValidade; }

    public LocalDate getDataReforco() { return dataReforco; }
    public void setDataReforco(LocalDate dataReforco) { this.dataReforco = dataReforco; }
}
