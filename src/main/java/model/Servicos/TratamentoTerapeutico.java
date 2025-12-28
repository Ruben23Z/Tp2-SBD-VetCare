package model.Servicos;

import model.ServicoMedicoAgendamento;

import java.time.LocalDateTime;

// TRATAMENTO TERAPÊUTICO
public class TratamentoTerapeutico extends ServicoMedicoAgendamento {
    private Integer frequencia; // frequência do tratamento
    private LocalDateTime dataHoraFim;
    private String tipoTratamento;

    public TratamentoTerapeutico(int idServico, String descricao) {
        super(idServico, descricao);
    }

    // getters e setters
    public Integer getFrequencia() { return frequencia; }
    public void setFrequencia(Integer frequencia) { this.frequencia = frequencia; }

    public LocalDateTime getDataHoraFim() { return dataHoraFim; }
    public void setDataHoraFim(LocalDateTime dataHoraFim) { this.dataHoraFim = dataHoraFim; }

    public String getTipoTratamento() { return tipoTratamento; }
    public void setTipoTratamento(String tipoTratamento) { this.tipoTratamento = tipoTratamento; }
}
