package model;

import model.Utilizador.Servico;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// CLASSE BASE: SERVICO MEDICO
public class ServicoMedicoAgendamento extends Servico {
     private LocalDateTime dataHoraInicio;
    private LocalDateTime dataHoraAgendada;
    private String estado; // 'ativo','cancelado','reagendado','rejeitado','pendente'
    private BigDecimal custoCancelamento;
    private int idPaciente;
    private Integer idUtilizador; // pode ser nulo
    private String localidade;
    private boolean fichaIniciadaRececionista;

    public ServicoMedicoAgendamento(int idServico, String descricao) {
        super(idServico, descricao);
    }

    // getters e setters
    public int getIdServico() { return idServico; }
    public void setIdServico(int idServico) { this.idServico = idServico; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public LocalDateTime getDataHoraInicio() { return dataHoraInicio; }
    public void setDataHoraInicio(LocalDateTime dataHoraInicio) { this.dataHoraInicio = dataHoraInicio; }

    public LocalDateTime getDataHoraAgendada() { return dataHoraAgendada; }
    public void setDataHoraAgendada(LocalDateTime dataHoraAgendada) { this.dataHoraAgendada = dataHoraAgendada; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public BigDecimal getCustoCancelamento() { return custoCancelamento; }
    public void setCustoCancelamento(BigDecimal custoCancelamento) { this.custoCancelamento = custoCancelamento; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public Integer getIdUtilizador() { return idUtilizador; }
    public void setIdUtilizador(Integer idUtilizador) { this.idUtilizador = idUtilizador; }

    public String getLocalidade() { return localidade; }
    public void setLocalidade(String localidade) { this.localidade = localidade; }

    public boolean isFichaIniciadaRececionista() { return fichaIniciadaRececionista; }
    public void setFichaIniciadaRececionista(boolean fichaIniciadaRececionista) { this.fichaIniciadaRececionista = fichaIniciadaRececionista; }
}
