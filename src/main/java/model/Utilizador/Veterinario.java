package model.Utilizador;

public class Veterinario extends Utilizador {
    private String nLicenca;
    private String nome;
    private int idade;
    private String especialidade;


    public Veterinario() {

    }

    public Veterinario(int iDUtilizador, String nLicenca, String nome, int idade, String especialidade) {
        super(iDUtilizador, true, false, false, false);
        this.nLicenca = nLicenca;
        this.nome = nome;
        this.idade = idade;
        this.especialidade = especialidade;
    }

    public String getnLicenca() {
        return nLicenca;
    }

    public void setnLicenca(String nLicenca) {
        this.nLicenca = nLicenca;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getIdade() {
        return idade;
    }

    public void setIdade(int idade) {
        this.idade = idade;
    }

    public String getEspecialidade() {
        return especialidade;
    }

    public void setEspecialidade(String especialidade) {
        this.especialidade = especialidade;
    }
}
