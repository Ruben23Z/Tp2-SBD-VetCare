package model;

public class Documenta {

    private int idServico;
    private String diagnostico;
    private String prescricoes;
    private String resultados;


//    VERIFICAR SE IDSERVICO FICA NO CONSTRUTOR
    public Documenta(int idServico, String diagnostico,
                     String prescricoes, String resultados) {
        this.idServico = idServico;
        this.diagnostico = diagnostico;
        this.prescricoes = prescricoes;
        this.resultados = resultados;
    }

    public int getIdServico() {
        return idServico;
    }

    public String getDiagnostico() {
        return diagnostico;
    }

    public String getPrescricoes() {
        return prescricoes;
    }

    public String getResultados() {
        return resultados;
    }
}
