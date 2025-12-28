package model;

import java.time.LocalDate;

public class Animal {

    private int iDPaciente;
    private String nome;
    private LocalDate dataNascimento;

    public Animal(int id, String nome, LocalDate dataNascimento) {
        this.iDPaciente = id;
        this.nome = nome;
        this.dataNascimento = dataNascimento;
    }

    public int getiDPaciente() {
        return iDPaciente;
    }

    public String getNome() {
        return nome;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }
}
