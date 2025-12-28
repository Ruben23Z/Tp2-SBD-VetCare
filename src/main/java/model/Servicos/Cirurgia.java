package model.Servicos;

import model.ServicoMedicoAgendamento;

import java.time.LocalDateTime;

// CIRURGIA
public class Cirurgia extends ServicoMedicoAgendamento {
    private String tipoCirurgia;
    private String anestesia;
    private String notas;
    private LocalDateTime dataHoraFim;

    public Cirurgia(int idServico, String descricao) {
        super(idServico, descricao);
    }

    // getters e setters
    public String getTipoCirurgia() { return tipoCirurgia; }
    public void setTipoCirurgia(String tipoCirurgia) { this.tipoCirurgia = tipoCirurgia; }

    public String getAnestesia() { return anestesia; }
    public void setAnestesia(String anestesia) { this.anestesia = anestesia; }

    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }

    public LocalDateTime getDataHoraFim() { return dataHoraFim; }
    public void setDataHoraFim(LocalDateTime dataHoraFim) { this.dataHoraFim = dataHoraFim; }
}
