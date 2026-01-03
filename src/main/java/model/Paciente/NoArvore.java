package model.Paciente;

import java.util.ArrayList;
import java.util.List;

public class NoArvore {
    private Paciente paciente;
    private String tipoParentesco; // ex: "Próprio", "Pai", "Mãe"
    private List<NoArvore> progenitores;

    public NoArvore(Paciente paciente, String tipoParentesco) {
        this.paciente = paciente;
        this.tipoParentesco = tipoParentesco;
        this.progenitores = new ArrayList<>();
    }

    public void adicionarProgenitor(NoArvore progenitor) {
        this.progenitores.add(progenitor);
    }

    // Getters
    public Paciente getPaciente() {
        return paciente;
    }

    public String getTipoParentesco() {
        return tipoParentesco;
    }

    public List<NoArvore> getProgenitores() {
        return progenitores;
    }
}