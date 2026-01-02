package model;

import java.time.LocalDateTime;

public class Servico {

    protected LocalDateTime dataHoraAgendada;
    protected int idServico;
    protected String descricao;
    protected LocalDateTime dataHoraInicio;
    private int idPaciente;
    private int idUtilizador;
    private String localidade;

    public Servico(int idServico, String descricao, LocalDateTime dataHoraAgendada, int idPaciente, int idUtilizador, String localidade) {
        this.idServico = idServico;
        this.descricao = descricao;
        this.dataHoraAgendada = dataHoraAgendada;
        this.idPaciente = idPaciente;
        this.idUtilizador = idUtilizador;
        this.localidade = localidade;
    }

    public Servico(int idServico, String descricao, LocalDateTime dataHoraInicio) {
        this.idServico = idServico;
        this.descricao = descricao;
        this.dataHoraInicio = dataHoraInicio;
    }

    public Integer getIdUtilizador() {
        return idUtilizador;
    }

    public void setIdUtilizador(int idUtilizador) {
        this.idUtilizador = idUtilizador;
    }

    public String getLocalidade() {
        return localidade;
    }

    public void setLocalidade(String localidade) {
        this.localidade = localidade;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public int getIdServico() {
        return idServico;
    }

    public LocalDateTime getDataHoraInicio() {
        return dataHoraInicio;
    }

    public String getDescricao() {
        return descricao;
    }
}
