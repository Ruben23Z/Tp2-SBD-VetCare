package model;

import java.sql.Date;
import java.time.LocalDate;

public class Paciente {

    private String nifDono;
    private int idPaciente;
    private String nome;
    private LocalDate dataNascimento;
    private double pesoAtual;
    private char sexo;
    private String raca;
    private String foto;
    // Construtor Vazio (Essencial para o Servlet criar o objeto)
    public Paciente() {}
    public Paciente(int idPaciente, String nome, LocalDate dataNascimento,
                    double pesoAtual, char sexo, String raca) {
        this.idPaciente = idPaciente;
        this.nome = nome;
        this.dataNascimento = dataNascimento;
        this.pesoAtual = pesoAtual;
        this.sexo = sexo;
        this.raca = raca;
    }

    public Paciente(int iDPaciente, String nome, LocalDate dataNascimento, double pesoAtual, char sexo, String raca, String foto, String nifDono) {
        this.idPaciente = iDPaciente;
        this.nome = nome;
        this.dataNascimento = dataNascimento;
        this.pesoAtual = pesoAtual;
        this.sexo = sexo;
        this.raca = raca;
        this.foto = foto;
        this.nifDono = nifDono;
    }

    public String getFoto() { return foto; }
    public void setFoto(String foto) { this.foto = foto; }

    public int getidPaciente() {
        return idPaciente;
    }
    public void setiDPaciente(int iDPaciente) { this.idPaciente = iDPaciente; }
    public String getNome() {
        return nome;
    }
    public void setNome(String nome) { this.nome = nome; }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }
    public void setDataNascimento(LocalDate data) {
        if (data != null) {
            this.dataNascimento = Date.valueOf(data).toLocalDate();
        }
    }
    public double getPesoAtual() {
        return pesoAtual;
    }
    public void setPesoAtual(double pesoAtual) { this.pesoAtual = pesoAtual; }
    public char getSexo() {
        return sexo;
    }
    public void setSexo(char sexo) { this.sexo = sexo; }

    public String getRaca() {
        return raca;
    }
    public void setRaca(String raca) { this.raca = raca; }
    public String getNifDono() { return nifDono; }
    public void setNifDono(String nifDono) { this.nifDono = nifDono; }
}
