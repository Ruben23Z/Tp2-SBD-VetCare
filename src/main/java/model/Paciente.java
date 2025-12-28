package model;

import java.time.LocalDate;

public class Paciente {

    private int idPaciente;
    private String nome;
    private LocalDate dataNascimento;
    private double pesoAtual;
    private char sexo;
    private String raca;

    public Paciente(int idPaciente, String nome, LocalDate dataNascimento,
                    double pesoAtual, char sexo, String raca) {
        this.idPaciente = idPaciente;
        this.nome = nome;
        this.dataNascimento = dataNascimento;
        this.pesoAtual = pesoAtual;
        this.sexo = sexo;
        this.raca = raca;
    }

    public int getidPaciente() {
        return idPaciente;
    }

    public String getNome() {
        return nome;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    public double getPesoAtual() {
        return pesoAtual;
    }

    public char getSexo() {
        return sexo;
    }

    public String getRaca() {
        return raca;
    }
}
