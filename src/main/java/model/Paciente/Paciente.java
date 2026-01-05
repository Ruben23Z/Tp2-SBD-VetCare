package model.Paciente;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Paciente {
    private int iDPaciente;
    private String nome;
    private LocalDate dataNascimento;
    private LocalDate dataObito;
    private int idade;
    private String filiacao;
    private String foto;
    private String transponder;
    private String cores;
    private double altura;
    private double pesoAtual;
    private char sexo; // 'M' ou 'F'
    private String alergias;
    private String estadoReprodutivo;
    private String observacoes;
    private String nifDono;
    private String raca;

    public Paciente() {
    }

    public Paciente(int iDPaciente, String nome, LocalDate dataNascimento, String nifDono, String raca) {
        this.iDPaciente = iDPaciente;
        this.nome = nome;
        this.dataNascimento = dataNascimento;
        this.nifDono = nifDono;
        this.raca = raca;
    }

    public String getIdadeFormatada() {
        if (dataNascimento == null) return "Desconhecida";
        // Se tiver dataObito, usa essa data como fim. Senão, usa a data de hoje.
        LocalDate fim = (dataObito != null) ? dataObito : LocalDate.now();
        if (dataNascimento.isAfter(fim)) return "Data Inválida";
        long dias = ChronoUnit.DAYS.between(dataNascimento, fim);
        // Lógica de apresentação: Dias -> Semanas -> Meses -> Anos
        if (dias < 30) {
            return dias + " dias";
        }
        if (dias < 60) { // Até ~2 meses mostramos em semanas
            long semanas = dias / 7;
            return semanas + " semanas";
        }
        long meses = ChronoUnit.MONTHS.between(dataNascimento, fim);
        if (meses < 24) { // Até 2 anos mostramos em meses
            return meses + " meses";
        }
        long anos = ChronoUnit.YEARS.between(dataNascimento, fim);
        return anos + " anos";
    }

    public String getEscalaoEtario() {
        if (dataNascimento == null) return "Desconhecido";
        long anos = ChronoUnit.YEARS.between(dataNascimento, LocalDate.now());
        if (anos < 1) return "Bebé";
        if (anos < 3) return "Jovem";
        if (anos < 10) return "Adulto";
        return "Idoso";
    }

    public int getidPaciente() {
        return iDPaciente;
    }

    public void setiDPaciente(int iDPaciente) {
        this.iDPaciente = iDPaciente;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    public void setDataNascimento(LocalDate dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    public int getIdade() {
        return idade;
    }

    public void setIdade(int idade) {
        this.idade = idade;
    }

    public String getFiliacao() {
        return filiacao;
    }
    public void setFiliacao(String filiacao) {
        this.filiacao = filiacao;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getTransponder() {
        return transponder;
    }

    public void setTransponder(String transponder) {
        this.transponder = transponder;
    }

    public String getCores() {
        return cores;
    }

    public void setCores(String cores) {
        this.cores = cores;
    }

    public double getAltura() {
        return altura;
    }

    public void setAltura(double altura) {
        this.altura = altura;
    }

    public double getPesoAtual() {
        return pesoAtual;
    }

    public void setPesoAtual(double pesoAtual) {
        this.pesoAtual = pesoAtual;
    }

    public char getSexo() {
        return sexo;
    }

    public void setSexo(char sexo) {
        this.sexo = sexo;
    }

    public String getAlergias() {
        return alergias;
    }

    public String getNifDono() {
        return nifDono;
    }

    public void setNifDono(String nifDono) {
        this.nifDono = nifDono;
    }

    public String getRaca() {
        return raca;
    }

    public void setRaca(String raca) {
        this.raca = raca;
    }

    public LocalDate getDataObito() {
        return dataObito;
    }

    public void setDataObito(LocalDate dataObito) {
        this.dataObito = dataObito;
    }
}