package model.Servicos;

import model.ServicoMedicoAgendamento;

import java.time.LocalDateTime;

// EXAME
public class Exame extends ServicoMedicoAgendamento {
    private String observacaoTecnica;
    private LocalDateTime dataHoraFim;
    private Integer duracao; // em minutos

    public Exame(int idServico, String descricao) {
        super(idServico, descricao);
    }

    // getters e setters
    public String getObservacaoTecnica() { return observacaoTecnica; }
    public void setObservacaoTecnica(String observacaoTecnica) { this.observacaoTecnica = observacaoTecnica; }

    public LocalDateTime getDataHoraFim() { return dataHoraFim; }
    public void setDataHoraFim(LocalDateTime dataHoraFim) { this.dataHoraFim = dataHoraFim; }

    public Integer getDuracao() { return duracao; }
    public void setDuracao(Integer duracao) { this.duracao = duracao; }
}
