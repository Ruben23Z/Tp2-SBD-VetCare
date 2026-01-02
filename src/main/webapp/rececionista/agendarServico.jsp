<%@ page import="java.util.List" %>
<%@ page import="model.Paciente" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page import="model.Utilizador.Veterinario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Paciente animal = (Paciente) request.getAttribute("animal");

    // --- PROTEÇÃO: Se não houver animal carregado, volta à lista ---
    if (animal == null) {
        response.sendRedirect(request.getContextPath() + "/AnimalServlet?acao=listar");
        return;
    }
    // -------------------------------------------------------------

    List<ServicoMedicoAgendamento> lista = (List<ServicoMedicoAgendamento>) request.getAttribute("listaAgendamentos");
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("listaVets");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Agendamentos</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f4f9; }
        .container { display: flex; gap: 20px; }
        .box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); flex: 1; }
        .alert { padding: 10px; margin-bottom: 10px; color: white; border-radius: 4px; text-align: center;}
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; border-bottom: 1px solid #ddd; text-align: left; }
        input, select { width: 95%; padding: 10px; margin: 5px 0 15px; border: 1px solid #ccc; border-radius: 4px; }
        .btn { padding: 8px 15px; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .green { background: #4CAF50; } .red { background: #f44336; } .blue { background: #2196F3; }
        .vet-list { font-size: 12px; color: #555; background: #eee; padding: 10px; border-radius: 5px; margin-top: 5px;}
    </style>
</head>
<body>

<div class="header">
    <h2 style="display:inline;">📅 Agenda: <%= animal.getNome() %></h2>
    <span style="margin-left: 15px; color: #666;">(Tutor NIF: <%= animal.getNifDono() %>)</span>
    <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar" style="float:right; text-decoration:none; padding:8px; background:#ddd; color:black; border-radius:4px;">Voltar</a>
</div>
<br>

<% if ("erroBD".equals(msg)) { %>
<div class="alert" style="background:#f44336">Erro: Verifique os dados (Data inválida ou ID do médico incorreto).</div>
<% } else if ("sucesso".equals(msg)) { %>
<div class="alert" style="background:#4CAF50">Sucesso!</div>
<% } %>

<div class="container">
    <div class="box">
        <h3>Novo Agendamento</h3>

        <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post">
            <input type="hidden" name="action" value="criar">
            <input type="hidden" name="idPaciente" value="<%= animal.getidPaciente() %>">

            <label>Serviço:</label>
            <select name="tipoServico" required>
                <option value="Consulta">Consulta</option>
                <option value="Vacinacao">Vacinação</option>
                <option value="Cirurgia">Cirurgia</option>
                <option value="Exame">Exame</option>
                <option value="TratamentoTerapeutico">Tratamento</option>
                <option value="Desparasitacao">Desparasitação</option>
            </select>

            <label>Descrição:</label>
            <input type="text" name="descricao" required placeholder="Motivo...">

            <label>Data/Hora:</label>
            <input type="datetime-local" name="dataHora" required>

            <label>ID do Veterinário:</label>
            <input type="text" name="idVeterinario" placeholder="ID numérico (ver lista abaixo)" required>

            <div class="vet-list">
                <strong>Médicos Disponíveis:</strong><br>
                <% if(vets != null && !vets.isEmpty()) {
                    for(Veterinario v : vets) { %>
                [<%= v.getiDUtilizador() %>] <%= v.getNome() %> - <%= v.getEspecialidade() %><br>
                <% }} else { %>
                Nenhum veterinário encontrado.
                <% } %>
            </div>

            <label>Clínica:</label>
            <select name="localidade" required>
                <option value="Serpa">Serpa</option>
                <option value="Odivelas">Odivelas</option>
                <option value="Quinta do Conde">Quinta do Conde</option>
            </select>

            <button type="submit" class="btn green">Agendar</button>
        </form>
    </div>

    <div class="box">
        <h3>Histórico</h3>
        <% if (lista == null || lista.isEmpty()) { %>
        <p style="color:#777; text-align:center;">Sem serviços agendados.</p>
        <% } else { %>
        <table>
            <tr><th>Data</th><th>Serviço</th><th>Estado</th><th>Ações</th></tr>
            <% for (ServicoMedicoAgendamento s : lista) { %>
            <tr>
                <td><%= (s.getDataHoraAgendada()!=null)?s.getDataHoraAgendada().toString().replace("T"," "):"-" %></td>
                <td><%= s.getDescricao() %></td>
                <td><%= s.getEstado() %></td>
                <td>
                    <% if (!"cancelado".equals(s.getEstado())) { %>
                    <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post" style="display:inline">
                        <input type="hidden" name="action" value="cancelar">
                        <input type="hidden" name="idPaciente" value="<%= animal.getidPaciente() %>">
                        <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                        <button type="submit" class="btn red">X</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>