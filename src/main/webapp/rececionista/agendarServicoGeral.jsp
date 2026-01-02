<%@ page import="java.util.List" %>
<%@ page import="model.Paciente" %>
<%@ page import="model.Utilizador.Veterinario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Paciente> animais = (List<Paciente>) request.getAttribute("listaAnimais");
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("listaVets");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Novo Agendamento</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f4f9; }
        .box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); max-width: 600px; margin: 0 auto; }
        label { display: block; margin-top: 10px; font-weight: bold; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; }
        .btn { padding: 10px; width: 100%; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; margin-top: 20px; }
    </style>
</head>
<body>
<div class="box">
    <h2>Agendar Serviço</h2>
    <a href="${pageContext.request.contextPath}/rececionista/menuRece.jsp">Voltar ao Menu</a>
    <br><br>

    <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post">
        <input type="hidden" name="action" value="criar">

        <label>1. Escolha o Animal:</label>
        <select name="idPaciente" required>
            <option value="" disabled selected>Selecione o paciente...</option>
            <% if(animais != null) { for(Paciente p : animais) { %>
            <option value="<%= p.getidPaciente() %>"><%= p.getNome() %> (Dono: <%= p.getNifDono() %>)</option>
            <% }} %>
        </select>

        <label>2. Tipo de Serviço:</label>
        <select name="tipoServico" required>
            <option value="Consulta">Consulta</option>
            <option value="Vacinacao">Vacinação</option>
            <option value="Cirurgia">Cirurgia</option>
            <option value="Exame">Exame</option>
        </select>

        <label>3. Descrição:</label>
        <input type="text" name="descricao" required>

        <label>4. Data e Hora:</label>
        <input type="datetime-local" name="dataHora" required>

        <label>5. ID do Veterinário:</label>
        <input type="text" name="idVeterinario" placeholder="ID numérico" required>
        <small style="color:#666;">
            Vets disponíveis:
            <% if(vets!=null) { for(Veterinario v:vets) { %> [<%= v.getiDUtilizador() %>] <%= v.getNome() %> <% }} %>
        </small>

        <label>6. Clínica:</label>
        <select name="localidade" required>
            <option value="Serpa">Serpa</option>
            <option value="Odivelas">Odivelas</option>
            <option value="Quinta do Conde">Quinta do Conde</option>
        </select>

        <button type="submit" class="btn">Confirmar Agendamento</button>
    </form>
</div>
</body>
</html>