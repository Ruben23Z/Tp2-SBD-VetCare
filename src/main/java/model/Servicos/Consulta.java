package model.Servicos;

import model.ServicoMedicoAgendamento;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// CONSULTA
public class Consulta extends ServicoMedicoAgendamento {
    private String diagnostico;
    private String sintomas;
    private String notas;
    private LocalDateTime proxConsulta;
    private Integer freqCardiaca;
    private Integer freqRespiratoria;
    private BigDecimal temp;
    private BigDecimal pesoMedido;
    private String motivo;

    public Consulta(int idServico, String descricao, LocalDateTime dataHoraInicio) {
        super(idServico, descricao, dataHoraInicio);
    }

    // getters e setters
    public String getDiagnostico() {
        return diagnostico;
    }

    public void setDiagnostico(String diagnostico) {
        this.diagnostico = diagnostico;
    }

    public String getSintomas() {
        return sintomas;
    }

    public void setSintomas(String sintomas) {
        this.sintomas = sintomas;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }

    public LocalDateTime getProxConsulta() {
        return proxConsulta;
    }

    public void setProxConsulta(LocalDateTime proxConsulta) {
        this.proxConsulta = proxConsulta;
    }

    public Integer getFreqCardiaca() {
        return freqCardiaca;
    }

    public void setFreqCardiaca(Integer freqCardiaca) {
        this.freqCardiaca = freqCardiaca;
    }

    public Integer getFreqRespiratoria() {
        return freqRespiratoria;
    }

    public void setFreqRespiratoria(Integer freqRespiratoria) {
        this.freqRespiratoria = freqRespiratoria;
    }

    public BigDecimal getTemp() {
        return temp;
    }

    public void setTemp(BigDecimal temp) {
        this.temp = temp;
    }

    public BigDecimal getPesoMedido() {
        return pesoMedido;
    }

    public void setPesoMedido(BigDecimal pesoMedido) {
        this.pesoMedido = pesoMedido;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }
}
