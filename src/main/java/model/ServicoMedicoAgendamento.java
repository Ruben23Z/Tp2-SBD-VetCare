package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ServicoMedicoAgendamento extends Servico {
    private LocalDateTime dataHoraAgendada;
    private String estado;
    private BigDecimal custoCancelamento;
    private int idPaciente;
    private Integer idUtilizador; // Pode ser NULO
    private String localidade;
    private boolean fichaIniciadaRececionista;
    private String tipoServico;
    private String nomeAnimal; // Para mostrar na tabela geral
    public ServicoMedicoAgendamento(int idServico, String descricao, LocalDateTime dataHoraInicio) {
        super(idServico, descricao, dataHoraInicio);
    }
    public String getNomeAnimal() { return nomeAnimal; }
    public void setNomeAnimal(String nomeAnimal) { this.nomeAnimal = nomeAnimal; }
    // Getters e Setters
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

    // --- CORREÇÃO FEITA AQUI: Agora retorna Integer ---
    public Integer getIdUtilizador() { return idUtilizador; }
    public void setIdUtilizador(Integer idUtilizador) { this.idUtilizador = idUtilizador; }

    public String getLocalidade() { return localidade; }
    public void setLocalidade(String localidade) { this.localidade = localidade; }

    public boolean isFichaIniciadaRececionista() { return fichaIniciadaRececionista; }
    public void setFichaIniciadaRececionista(boolean fichaIniciadaRececionista) { this.fichaIniciadaRececionista = fichaIniciadaRececionista; }
    public String getTipoServico() { return tipoServico; }
    public void setTipoServico(String tipoServico) { this.tipoServico = tipoServico; }

}